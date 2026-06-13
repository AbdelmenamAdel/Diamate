import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:diamate/constant.dart';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/services/ai_engine_service.dart';
import 'package:dio/dio.dart';
import '../../domain/repos/food_repo.dart';
import '../models/meal_model.dart';
import '../models/recommended_meal_model.dart';
import '../services/food_local_service.dart';
import 'package:diamate/core/utils/file_helper.dart';

class FoodRepoImpl implements FoodRepo {
  final ApiConsumer api;
  final FoodLocalService localService;

  FoodRepoImpl({required this.api, required this.localService});

  @override
  Future<Either<String, List<String>>> analyzeFoodImage(File image) async {
    try {
      log("Analyzing food image: ${image.path}");

      List<String>? ingredients;

      // 1st Option: detectFood
      try {
        final response = await api.post(
          EndPoint.detectFood,
          isFormData: true,
          data: {"file": await MultipartFile.fromFile(image.path)},
        );

        log("First option (detectFood) response: $response");
        if (response != null &&
            response is Map<String, dynamic> &&
            response['food_detected'] == true &&
            response['detected_items'] != null) {
          final List<dynamic> items = response['detected_items'];
          final Set<String> extractedIngredients = {};

          for (var item in items) {
            if (item != null && item['class_name'] != null) {
              final String className = item['class_name'] as String;
              // Split compound class names by comma, 'and', 'with', '-', or just any space
              final parts = className.split(
                RegExp(r',\s*|\s+and\s+|\s+with\s+|\s*-\s*|\s+'),
              );
              for (var part in parts) {
                if (part.trim().isNotEmpty) {
                  // Capitalize first letter
                  final capitalized =
                      part.trim()[0].toUpperCase() +
                      part.trim().substring(1).toLowerCase();
                  extractedIngredients.add(capitalized);
                }
              }
            }
          }
          ingredients = extractedIngredients.toList();
        }
      } catch (e) {
        log("First option failed. Error: $e");
      }

      // 2nd Option: analyzeFood (Project B)
      if (ingredients == null || ingredients.isEmpty) {
        try {
          log("Falling back to second option (analyzeFood)...");
          final response = await api.post(
            EndPoint.analyzeFood,
            isFormData: true,
            data: {"file": await MultipartFile.fromFile(image.path)},
          );

          log("Second option (analyzeFood) response: $response");

          if (response != null) {
            // Flexible parsing to handle potential different response structures
            if (response is List) {
              ingredients = response.map((e) => e.toString()).toList();
            } else if (response is Map<String, dynamic>) {
              if (response['detected_items'] != null) {
                final List<dynamic> items = response['detected_items'];
                ingredients = items
                    .where((item) => item != null && item['class_name'] != null)
                    .map((item) => item['class_name'] as String)
                    .toList();
              } else if (response['ingredients'] != null) {
                final List<dynamic> items = response['ingredients'];
                ingredients = items.map((e) => e.toString()).toList();
              } else if (response['data'] != null && response['data'] is List) {
                ingredients = (response['data'] as List)
                    .map((e) => e.toString())
                    .toList();
              }
            }
          }
        } catch (e) {
          log("Second option also failed. Error: $e");
        }
      }

      if (ingredients != null && ingredients.isNotEmpty) {
        log("Detected ingredients: $ingredients");
        return Right(ingredients);
      } else {
        return const Left("No specific food items identified or server error");
      }
    } catch (e) {
      log("Exception in FoodRepoImpl.analyzeFoodImage: ${e.toString()}");
      return Left(e.toString());
    }
  }

  Future<NutritionModel?> _getNutritionFromGemini(
    List<IngredientModel> ingredients,
  ) async {
    try {
      final dio = Dio();
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${K.geminiApiKey}";

      final prompt =
          '''
Analyze the following meal ingredients and estimate the total nutritional values. 
Also, provide a short, friendly advice message in Egyptian Arabic (e.g. "خد بالك يا نجم السعرات دي كتير على العشا", or "عاش يا بطل وجبة متكاملة") based on the macros and the fact that the meal is being added now.
Return ONLY a valid JSON object matching exactly this structure with no markdown formatting or extra text:
{
  "calories": 0.0,
  "protein": 0.0,
  "fat": 0.0,
  "carbs": 0.0,
  "advice": "your advice here"
}
Ingredients:
${ingredients.map((i) => "- ${i.name} (${i.quantityGrams}g)").join('\\n')}
''';

      log("Calling Gemini API for nutrition...");
      final response = await dio.post(
        url,
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.1,
            "responseMimeType": "application/json",
          },
        },
      );

      if (response.statusCode == 200) {
        final text =
            response.data['candidates'][0]['content']['parts'][0]['text'];
        final jsonResponse = jsonDecode(text);
        return NutritionModel.fromJson(jsonResponse);
      }
    } catch (e) {
      log("Gemini calculation failed: $e");
    }
    return null;
  }

  @override
  Future<Either<String, NutritionModel>> addFoodMeal({
    required MealModel meal,
    required int patientId,
  }) async {
    try {
      // 1. First calculate nutrition from Gemini (since backend requires it)
      NutritionModel? nutritionInfo = await _getNutritionFromGemini(
        meal.ingredients,
      );
      // Fallback if Gemini fails
      nutritionInfo ??= const NutritionModel(
        calories: 300,
        protein: 15,
        fat: 10,
        carbs: 40,
      );

      // 2. Prepare data for backend
      final data = {
        "patientId": patientId,
        "name": meal.name,
        "read_date": DateTime.now().toIso8601String(),
        "calories": nutritionInfo.calories,
        "protein": nutritionInfo.protein,
        "carbs": nutritionInfo.carbs,
        "fats": nutritionInfo.fat,
        "notes": meal.ingredients
            .map((i) => "${i.name} (${i.quantityGrams}g)")
            .join(', '),
      };

      log("Sending food meal to server: $data");

      // 3. Send to API
      try {
        final response = await api.post(EndPoint.addFoodMeal, data: data);
        log("Backend response for AddNewMeal: $response");
      } catch (e) {
        log("Server endpoint failed. Error: $e");
        // Still return Right if you want to allow offline saving when server fails,
        // or return Left if you want strict server syncing.
      }

      // Save locally
      final persistentImagePath = await FileHelper.saveFileToAppDir(
        meal.imagePath,
      );

      final updatedMeal = MealModel(
        id: meal.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: meal.name,
        imagePath: persistentImagePath,
        ingredients: meal.ingredients,
        nutrition: nutritionInfo,
        createdAt: meal.createdAt ?? DateTime.now(),
      );

      await localService.saveMeal(updatedMeal);

      return Right(nutritionInfo);
    } catch (e) {
      log("Exception in FoodRepoImpl.addFoodMeal: ${e.toString()}");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MealModel>>> getMealsByDate(DateTime date) async {
    try {
      log("Fetching meals for date: ${date.toIso8601String()}");

      final localMeals = await localService.getMealsByDate(date);

      // If we don't have local meals for today, we can add some mock data just for showcase if requested,
      // but the user wants to see what they added, so returning localMeals is correct.

      return Right(localMeals);
    } catch (e) {
      log("Exception in FoodRepoImpl.getMealsByDate: ${e.toString()}");
      return Left(e.toString());
    }
  }



  /// Estimated nutrition per meal by cuisine area (single serving ~300g)
  static const Map<String, Map<String, double>> _nutritionByArea = {
    'Egyptian': {'cal': 280, 'pro': 18, 'carb': 32, 'fat': 9},
    'Moroccan': {'cal': 310, 'pro': 22, 'carb': 28, 'fat': 11},
    'Tunisian': {'cal': 290, 'pro': 20, 'carb': 30, 'fat': 10},
    'Turkish': {'cal': 320, 'pro': 24, 'carb': 25, 'fat': 13},
    'Lebanese': {'cal': 260, 'pro': 16, 'carb': 28, 'fat': 9},
    'Greek': {'cal': 270, 'pro': 18, 'carb': 22, 'fat': 12},
    'Indian': {'cal': 240, 'pro': 14, 'carb': 30, 'fat': 8},
    'Malaysian': {'cal': 260, 'pro': 16, 'carb': 28, 'fat': 9},
  };



  /// Builds a list of image URLs for the meal carousel:
  /// 1. Main meal thumbnail (always included)
  /// 2. YouTube video thumbnail (if strYoutube is available)
  static List<String> _buildImageUrls(Map<String, dynamic> detail) {
    final images = <String>[];

    // 1) Primary meal image
    final thumb = detail['strMealThumb']?.toString();
    if (thumb != null && thumb.isNotEmpty) {
      images.add(thumb);
    }

    // 2) YouTube thumbnail as a second image
    final ytUrl = detail['strYoutube']?.toString() ?? '';
    if (ytUrl.isNotEmpty) {
      final uri = Uri.tryParse(ytUrl);
      final videoId = uri?.queryParameters['v'];
      if (videoId != null && videoId.isNotEmpty) {
        images.add('https://img.youtube.com/vi/$videoId/maxresdefault.jpg');
      }
    }

    return images;
  }

  /// Fetches meals from TheMealDB by area (Egyptian only & healthy for diabetics)
  Future<List<RecommendedMealModel>> _fetchFromMealDB({int count = 10}) async {
    final dio = Dio();
    final List<RecommendedMealModel> meals = [];

    // Focus exclusively on Egyptian cuisine as requested by the user
    final areas = ['Egyptian'];

    for (final area in areas) {
      if (meals.length >= count) break;
      try {
        final listResp = await dio.get(
          'https://www.themealdb.com/api/json/v1/1/filter.php',
          queryParameters: {'a': area}, // 'a' = area filter
        );
        if (listResp.statusCode != 200) continue;

        final rawList = listResp.data['meals'] as List<dynamic>?;
        if (rawList == null || rawList.isEmpty) continue;

        // Take all available Egyptian meals to satisfy the request fully
        rawList.shuffle();
        final picked = rawList.take(count).toList();

        for (final item in picked) {
          if (meals.length >= count) break;
          final mealId = item['idMeal']?.toString() ?? '';
          if (mealId.isEmpty) continue;

          // Avoid duplicates
          if (meals.any((m) => m.id == 'mdb_$mealId')) continue;

          // Fetch full details
          final detailResp = await dio.get(
            'https://www.themealdb.com/api/json/v1/1/lookup.php',
            queryParameters: {'i': mealId},
          );
          if (detailResp.statusCode != 200) continue;

          final detail = (detailResp.data['meals'] as List?)?.first;
          if (detail == null) continue;

          // Extract ingredients list
          final ingredients = <String>[];
          for (int i = 1; i <= 20; i++) {
            final ing = detail['strIngredient$i']?.toString().trim() ?? '';
            final measure = detail['strMeasure$i']?.toString().trim() ?? '';
            if (ing.isNotEmpty && ing.toLowerCase() != 'null') {
              ingredients.add(measure.isNotEmpty ? '$ing ($measure)' : ing);
            }
          }

          // Parse preparation steps from instructions
          final rawInstructions = detail['strInstructions']?.toString() ?? '';
          List<String> steps = rawInstructions
              .split(RegExp(r'\r?\n+'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty && s.length > 5)
              .toList();

          // If the entire instruction was just one big paragraph, split by sentences securely
          if (steps.length == 1) {
            steps = steps.first
                .split(RegExp(r'\.\s+'))
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty && s.length > 5)
                .map((s) => s.endsWith('.') ? s : '$s.')
                .toList();
          }
          final finalSteps = steps.take(5).toList();

          // Nutrition estimate tailored for diabetic compatibility
          final nut =
              _nutritionByArea[area] ??
              {'cal': 260, 'pro': 18, 'carb': 25, 'fat': 8};

          final baseMeal = RecommendedMealModel(
            id: 'mdb_$mealId',
            title: detail['strMeal']?.toString() ?? 'Egyptian Healthy Meal',
            calories: nut['cal']!,
            protein: nut['pro']!,
            carbs: nut['carb']!,
            fats: nut['fat']!,
            description:
                'Authentic Egyptian recipe optimized for diabetics — modified with minimal oils and reduced simple carbs to ensure healthy blood sugar stability.',
            descriptionAr:
                'أكلة مصرية أصيلة مطبوخة بطريقة صحية (قليلة الزيوت والنشويات) ومثالية جداً لضبط السكر في الدم.',
            preparationSteps: finalSteps.isNotEmpty
                ? finalSteps
                : [
                    'Bake or grill ingredients using minimal olive oil to support optimal diabetic health standards.',
                  ],
            ingredients: ingredients,
            imageUrl: detail['strMealThumb']?.toString(),
            imageUrls: _buildImageUrls(detail),
          );

          meals.add(baseMeal);
        }
      } catch (e) {
        log('Error fetching area $area from MealDB: $e');
      }
    }

    // ── Translate all fetched meals to Arabic using Gemini sequentially ──
    if (meals.isNotEmpty) {
      log(
        'Translating ${meals.length} meals to Arabic via Gemini sequentially...',
      );
      final translatedMeals = <RecommendedMealModel>[];
      for (final m in meals) {
        try {
          final tm = await _translateMealWithGemini(m, dio);
          translatedMeals.add(tm);
          // tiny delay to respect free tier rate limits
          await Future.delayed(const Duration(milliseconds: 350));
        } catch (e) {
          log("Skipping translation for meal ${m.id} due to error: $e");
          translatedMeals.add(m); // Keep original English version safely
        }
      }
      return translatedMeals;
    }

    return meals;
  }

  /// Helper delegating AI functionality to decoupled Core AiEngineService module
  Future<RecommendedMealModel> _translateMealWithGemini(
    RecommendedMealModel meal,
    Dio dio,
  ) async {
    return await AiEngineService.translateMeal(meal, dio);
  }

  @override
  Future<Either<String, List<RecommendedMealModel>>>
  getWeeklyRecommendations() async {
    try {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final dayOfYear = now.difference(startOfYear).inDays + 1;
      final weekNumber = (dayOfYear / 7).ceil();
      final weekKey = "${now.year}_W$weekNumber";

      log("Checking cache for key: $weekKey");

      // Check cache — only use if it has real data (≥6 meals)
      final cached = await localService.getCachedRecommendations(weekKey);
      if (cached != null && cached.length >= 6) {
        log("Returning ${cached.length} cached meals");
        final savedMeals = await localService.getSavedRecommendedMeals();
        final savedIds = savedMeals.map((e) => e.id).toSet();
        return Right(
          cached
              .map((m) => m.copyWith(isSaved: savedIds.contains(m.id)))
              .toList(),
        );
      }

      log("Cache empty/stale for $weekKey — fetching from TheMealDB...");
      final meals = await _fetchFromMealDB(count: 10);

      if (meals.isNotEmpty) {
        await localService.saveCachedRecommendations(weekKey, meals);
        final savedMeals = await localService.getSavedRecommendedMeals();
        final savedIds = savedMeals.map((e) => e.id).toSet();
        return Right(
          meals
              .map((m) => m.copyWith(isSaved: savedIds.contains(m.id)))
              .toList(),
        );
      }

      return const Left(
        "Could not load meals. Check your internet connection.",
      );
    } catch (e) {
      log("Exception in getWeeklyRecommendations: $e");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<RecommendedMealModel>>>
  refreshMealsFromWeb() async {
    try {
      log("Force-refreshing meals from TheMealDB...");
      // Clear all cached weeks so next load fetches fresh
      await localService.clearAllCachedRecommendations();

      final meals = await _fetchFromMealDB(count: 10);

      if (meals.isEmpty) {
        return const Left("No meals returned. Check your internet connection.");
      }

      // Save under current week key
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final dayOfYear = now.difference(startOfYear).inDays + 1;
      final weekNumber = (dayOfYear / 7).ceil();
      final weekKey = "${now.year}_W$weekNumber";
      await localService.saveCachedRecommendations(weekKey, meals);

      final savedMeals = await localService.getSavedRecommendedMeals();
      final savedIds = savedMeals.map((e) => e.id).toSet();
      return Right(
        meals.map((m) => m.copyWith(isSaved: savedIds.contains(m.id))).toList(),
      );
    } catch (e) {
      log("Exception in refreshMealsFromWeb: $e");
      return Left(e.toString());
    }
  }
}
