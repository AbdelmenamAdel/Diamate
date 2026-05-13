import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:diamate/constant.dart';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
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

  Future<List<String>?> _getIngredientsFromGemini(File image) async {
    try {
      final dio = Dio();
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${K.geminiApiKey}";

      final imageBytes = await image.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final ext = image.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      final prompt = '''
Analyze this food image and list the main visible ingredients.
Return ONLY a valid JSON array of strings, for example: ["Chicken", "Rice", "Tomato"].
Do not include any other text or markdown formatting.
''';

      log("Calling Gemini API for image analysis...");
      final response = await dio.post(
        url,
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
                {
                  "inlineData": {"mimeType": mimeType, "data": base64Image},
                },
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.4,
            "responseMimeType": "application/json",
          },
        },
      );

      if (response.statusCode == 200) {
        final text =
            response.data['candidates'][0]['content']['parts'][0]['text'];
        final List<dynamic> jsonList = jsonDecode(text);
        return jsonList.map((e) => e.toString()).toList();
      }
    } catch (e) {
      log("Gemini image analysis failed: $e");
    }
    return null;
  }

  @override
  Future<Either<String, List<String>>> analyzeFoodImage(File image) async {
    try {
      log("Analyzing food image: ${image.path}");

      List<String>? ingredients;

      try {
        final response = await api.post(
          EndPoint.detectFood,
          isFormData: true,
          data: {"file": await MultipartFile.fromFile(image.path)},
        );

        log("Food analysis response: $response");
        if (response != null &&
            response is Map<String, dynamic> &&
            response['food_detected'] == true &&
            response['detected_items'] != null) {
          final List<dynamic> items = response['detected_items'];
          ingredients = items
              .where((item) => item != null && item['class_name'] != null)
              .map((item) => item['class_name'] as String)
              .toList();
        }
      } catch (e) {
        log("Server endpoint failed, falling back to Gemini API. Error: $e");
      }

      if (ingredients == null || ingredients.isEmpty) {
        ingredients = await _getIngredientsFromGemini(image);
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
      final data = {
        "patientId": patientId,
        "mealName": meal.name,
        "mealImage": meal.imagePath,
        "ingredients": meal.ingredients.map((i) => i.toJson()).toList(),
      };

      log("Sending food meal to server: $data");

      NutritionModel? nutritionInfo;

      try {
        final response = await api.post(EndPoint.addFoodMeal, data: data);
        if (response != null) {
          nutritionInfo = NutritionModel.fromJson(
            response as Map<String, dynamic>,
          );
        }
      } catch (e) {
        log("Server endpoint failed, falling back to Gemini API. Error: $e");
      }

      // Generate nutrition from Gemini if server failed
      if (nutritionInfo == null) {
        nutritionInfo = await _getNutritionFromGemini(meal.ingredients);
        // Fallback to mock if Gemini also fails
        nutritionInfo ??= const NutritionModel(
          calories: 300,
          protein: 15,
          fat: 10,
          carbs: 40,
        );
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

  // ============================================================
  // TheMealDB categories to fetch healthy meals from
  // ============================================================
  static const List<String> _healthyCategories = [
    'Chicken',
    'Seafood',
    'Vegetarian',
    'Beef',
    'Lamb',
    'Pasta',
    'Vegan',
    'Breakfast',
  ];

  /// Estimated nutrition per 100g by category (reasonable healthy portions)
  static const Map<String, Map<String, double>> _nutritionByCategory = {
    'Chicken': {'cal': 215, 'pro': 25, 'carb': 0, 'fat': 12},
    'Seafood': {'cal': 180, 'pro': 28, 'carb': 0, 'fat': 7},
    'Vegetarian': {'cal': 160, 'pro': 8, 'carb': 22, 'fat': 5},
    'Beef': {'cal': 250, 'pro': 26, 'carb': 2, 'fat': 15},
    'Lamb': {'cal': 290, 'pro': 25, 'carb': 0, 'fat': 20},
    'Pasta': {'cal': 220, 'pro': 9, 'carb': 38, 'fat': 5},
    'Vegan': {'cal': 140, 'pro': 6, 'carb': 20, 'fat': 4},
    'Breakfast': {'cal': 200, 'pro': 12, 'carb': 18, 'fat': 9},
  };

  /// Fetches meals from TheMealDB API and converts to RecommendedMealModel
  Future<List<RecommendedMealModel>> _fetchFromMealDB({int count = 10}) async {
    final dio = Dio();
    final List<RecommendedMealModel> meals = [];
    final shuffledCats = List<String>.from(_healthyCategories)..shuffle();

    // Fetch meals across categories until we have [count]
    for (final category in shuffledCats) {
      if (meals.length >= count) break;
      try {
        final listResp = await dio.get(
          'https://www.themealdb.com/api/json/v1/1/filter.php',
          queryParameters: {'c': category},
        );
        if (listResp.statusCode != 200) continue;

        final rawList = listResp.data['meals'] as List<dynamic>?;
        if (rawList == null || rawList.isEmpty) continue;

        // Pick up to 2 random meals from this category
        rawList.shuffle();
        final picked = rawList.take(2).toList();

        for (final item in picked) {
          if (meals.length >= count) break;
          final mealId = item['idMeal']?.toString() ?? '';
          if (mealId.isEmpty) continue;

          // Fetch full details
          final detailResp = await dio.get(
            'https://www.themealdb.com/api/json/v1/1/lookup.php',
            queryParameters: {'i': mealId},
          );
          if (detailResp.statusCode != 200) continue;

          final detail = (detailResp.data['meals'] as List?)?.first;
          if (detail == null) continue;

          // Extract ingredients
          final ingredients = <String>[];
          for (int i = 1; i <= 20; i++) {
            final ing = detail['strIngredient$i']?.toString().trim() ?? '';
            final measure = detail['strMeasure$i']?.toString().trim() ?? '';
            if (ing.isNotEmpty && ing != 'null') {
              ingredients.add(measure.isNotEmpty ? '$ing ($measure)' : ing);
            }
          }

          // Parse instructions into steps
          final rawInstructions = detail['strInstructions']?.toString() ?? '';
          final steps = rawInstructions
              .split(RegExp(r'\r?\n+'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty && s.length > 5)
              .take(6)
              .toList();

          // Nutrition estimate based on category
          final nut =
              _nutritionByCategory[category] ??
              {'cal': 200, 'pro': 15, 'carb': 20, 'fat': 8};

          meals.add(
            RecommendedMealModel(
              id: 'mdb_${mealId}',
              title: detail['strMeal']?.toString() ?? 'Healthy Meal',
              calories: nut['cal']!,
              protein: nut['pro']!,
              carbs: nut['carb']!,
              fats: nut['fat']!,
              description:
                  '${detail['strArea'] ?? ''} • ${category} dish — rich in nutrients, great for blood sugar balance.',
              preparationSteps: steps.isNotEmpty
                  ? steps
                  : ['Follow the standard preparation method for this dish.'],
              ingredients: ingredients,
              imageUrl: detail['strMealThumb']?.toString(),
            ),
          );
        }
      } catch (e) {
        log('Error fetching category $category from MealDB: $e');
      }
    }
    return meals;
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
