import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_model.dart';
import '../../../../core/services/hive/hive_service.dart';

class FoodLocalService {
  static const String _boxName = 'food_meals_box';

  Future<Box<String>> _getBox() async {
    return await HiveService.openBox<String>(_boxName);
  }

  Future<void> saveMeal(MealModel meal) async {
    final box = await _getBox();
    final mealJson = jsonEncode(
      meal.toJson()
        ..['createdAt'] =
            meal.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
    );
    // Use an ID if available or generate one
    final id = meal.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(id, mealJson);
  }

  Future<List<MealModel>> getMealsByDate(DateTime date) async {
    final box = await _getBox();
    final allMeals = box.values
        .map((jsonStr) => MealModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    // Filter by date
    return allMeals.where((meal) {
      if (meal.createdAt == null) return false;
      return meal.createdAt!.year == date.year &&
          meal.createdAt!.month == date.month &&
          meal.createdAt!.day == date.day;
    }).toList();
  }
}
