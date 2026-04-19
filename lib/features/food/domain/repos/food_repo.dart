import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../data/models/meal_model.dart';

abstract class FoodRepo {
  Future<Either<String, List<String>>> analyzeFoodImage(File image);
  Future<Either<String, NutritionModel>> addFoodMeal({
    required MealModel meal,
    required int patientId,
  });
}
