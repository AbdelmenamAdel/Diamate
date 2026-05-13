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

  @override
  Future<Either<String, List<RecommendedMealModel>>>
  getWeeklyRecommendations() async {
    try {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final dayOfYear = now.difference(startOfYear).inDays + 1;
      final weekNumber = (dayOfYear / 7).ceil();
      final weekKey = "${now.year}_W$weekNumber";

      log("Fetching weekly recommendations for key: $weekKey");

      // Check cache
      final cached = await localService.getCachedRecommendations(weekKey);
      if (cached != null && cached.isNotEmpty) {
        log("Returning cached weekly recommendations");
        final savedMeals = await localService.getSavedRecommendedMeals();
        final savedIds = savedMeals.map((e) => e.id).toSet();
        final synced = cached
            .map((m) => m.copyWith(isSaved: savedIds.contains(m.id)))
            .toList();
        return Right(synced);
      }

      log("Cache empty for week $weekKey. Prompting Gemini API...");

      final dio = Dio();
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${K.geminiApiKey}";

      final prompt = '''
Generate a list of 10 delicious, highly nutritious, healthy diabetic-friendly meals for this week.
Each meal must have low glycemic impact, balanced macros, an appealing short description in simple Arabic or Egyptian Arabic, detailed ingredients, and clear step-by-step preparation instructions in simple Arabic.
Return ONLY a valid JSON array matching exactly this structure with no markdown formatting or extra text:
[
  {
    "id": "meal_1",
    "title": "سلطة دجاج مشوي بالكينوا",
    "calories": 320.0,
    "protein": 35.0,
    "carbs": 20.0,
    "fats": 12.0,
    "description": "وجبة مشبعة وغنية بالألياف تساعد على استقرار السكر في الدم لفترات طويلة.",
    "preparationSteps": [
      "اشوي صدور الدجاج المتبلة بزيت الزيتون والليمون.",
      "اسلق الكينوا واتركها تبرد.",
      "اخلط الدجاج والكينوا مع الخضار الورقية وقدمها."
    ],
    "ingredients": [
      "صدور دجاج (150 جم)",
      "كينوا مطبوخة (50 جم)",
      "خس وخيار وطماطم"
    ]
  }
]
''';

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
            "temperature": 0.4,
            "responseMimeType": "application/json",
          },
        },
      );

      if (response.statusCode == 200) {
        final text =
            response.data['candidates'][0]['content']['parts'][0]['text'];
        final List<dynamic> jsonList = jsonDecode(text);
        final List<RecommendedMealModel> meals = jsonList.map((e) {
          final mMap = Map<String, dynamic>.from(e as Map);
          // Simple consistent key per week
          final baseId =
              mMap['id']?.toString() ??
              DateTime.now().microsecondsSinceEpoch.toString();
          mMap['id'] = "${weekKey}_$baseId";
          return RecommendedMealModel.fromJson(mMap);
        }).toList();

        // Save cache
        await localService.saveCachedRecommendations(weekKey, meals);

        final savedMeals = await localService.getSavedRecommendedMeals();
        final savedIds = savedMeals.map((e) => e.id).toSet();
        final synced = meals
            .map((m) => m.copyWith(isSaved: savedIds.contains(m.id)))
            .toList();

        return Right(synced);
      } else {
        return const Left("Failed to generate recommendations from Gemini");
      }
    } catch (e) {
      log("Exception in getWeeklyRecommendations: $e");
      final mockMeals = [
        const RecommendedMealModel(
          id: "mock_1",
          title: "سلطة دجاج مشوي بالكينوا",
          calories: 320,
          protein: 35,
          carbs: 20,
          fats: 12,
          description:
              "وجبة مشبعة وغنية بالألياف تساعد على استقرار السكر في الدم لفترات طويلة.",
          preparationSteps: [
            "اشوي صدور الدجاج المتبلة بزيت الزيتون والليمون.",
            "اسلق الكينوا واتركها تبرد.",
            "اخلط الدجاج والكينوا مع الخضار الورقية وقدمها.",
          ],
          ingredients: [
            "صدور دجاج (150 جم)",
            "كينوا مطبوخة (50 جم)",
            "خس وخيار وطماطم",
          ],
        ),
        const RecommendedMealModel(
          id: "mock_2",
          title: "سالمون مشوي مع البروكلي",
          calories: 380,
          protein: 40,
          carbs: 10,
          fats: 18,
          description:
              "غنية بأحماض أوميجا 3 المفيدة للقلب ولا ترفع سكر الدم بشكل مفاجئ.",
          preparationSteps: [
            "تبل شريحة السالمون بالثوم والشبت وزيت الزيتون.",
            "اشوي السالمون في الفرن لمدة 15 دقيقة.",
            "قدمه مع زهور البروكلي المطهوة على البخار.",
          ],
          ingredients: [
            "شريحة سالمون (180 جم)",
            "بروكلي (100 جم)",
            "زيت زيتون وثوم",
          ],
        ),
      ];
      return Right(mockMeals);
    }
  }
}
