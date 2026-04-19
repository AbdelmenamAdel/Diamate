import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/error/exception.dart';
import '../../domain/repos/food_repo.dart';
import '../models/meal_model.dart';

class FoodRepoImpl implements FoodRepo {
  final ApiConsumer api;

  FoodRepoImpl({required this.api});

  @override
  Future<Either<String, List<String>>> analyzeFoodImage(File image) async {
    try {
      log("Analyzing food image: ${image.path}");
      
      // Simulating a network delay for the analysis
      await Future.delayed(const Duration(seconds: 2));

      // Mock response as requested by the user for now
      final mockIngredients = ["Chicken Breast", "Brown Rice", "Steamed Broccoli", "Olive Oil"];
      
      return Right(mockIngredients);
    } catch (e) {
      log("Exception in FoodRepoImpl.analyzeFoodImage: ${e.toString()}");
      return Left(e.toString());
    }
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

      final response = await api.post(
        EndPoint.addFoodMeal,
        data: data,
      );

      if (response != null) {
        // Assume the response contains the calculated nutrition info
        return Right(NutritionModel.fromJson(response as Map<String, dynamic>));
      } else {
        return const Left("Failed to add meal to server");
      }
    } on ServerFailure catch (e) {
      log("ServerFailure in FoodRepoImpl.addFoodMeal: ${e.errorModel.errorMessage}");
      return Left(e.errorModel.errorMessage ?? "Server error occurred");
    } catch (e) {
      log("Exception in FoodRepoImpl.addFoodMeal: ${e.toString()}");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MealModel>>> getMealsByDate(DateTime date) async {
    try {
      log("Fetching meals for date: ${date.toIso8601String()}");
      
      // Simulating API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mocking data: Return meals for "today" and "yesterday"
      final now = DateTime.now();
      final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
      final isYesterday = date.day == now.subtract(const Duration(days: 1)).day;

      if (isToday) {
        return Right([
          const MealModel(
            id: "1",
            name: "Healthy Breakfast",
            ingredients: [
              IngredientModel(name: "Oats", quantityGrams: 50),
              IngredientModel(name: "Milk", quantityGrams: 200),
              IngredientModel(name: "Banana", quantityGrams: 100),
            ],
            nutrition: NutritionModel(calories: 350, protein: 12, fat: 8, carbs: 55),
            createdAt: null,
          ),
          const MealModel(
            id: "2",
            name: "Grilled Chicken Salad",
            ingredients: [
              IngredientModel(name: "Chicken", quantityGrams: 150),
              IngredientModel(name: "Lettuce", quantityGrams: 100),
              IngredientModel(name: "Olive Oil", quantityGrams: 10),
            ],
            nutrition: NutritionModel(calories: 420, protein: 35, fat: 22, carbs: 12),
            createdAt: null,
          ),
        ]);
      } else if (isYesterday) {
        return Right([
          const MealModel(
            id: "3",
            name: "Protein Pasta",
            ingredients: [
              IngredientModel(name: "Whole Wheat Pasta", quantityGrams: 100),
              IngredientModel(name: "Tomato Sauce", quantityGrams: 50),
              IngredientModel(name: "Turkey Mince", quantityGrams: 120),
            ],
            nutrition: NutritionModel(calories: 580, protein: 42, fat: 15, carbs: 65),
            createdAt: null,
          ),
        ]);
      } else {
        // Return empty list for other days to show "no records" state
        return const Right([]);
      }
    } catch (e) {
      log("Exception in FoodRepoImpl.getMealsByDate: ${e.toString()}");
      return Left(e.toString());
    }
  }
}
