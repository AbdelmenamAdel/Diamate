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
}
