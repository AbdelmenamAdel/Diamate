import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_model.dart';
import '../models/recommended_meal_model.dart';
import '../../../../core/services/hive/hive_service.dart';

class FoodLocalService {
  static const String _boxName = 'food_meals_box';
  static const String _recommendationsBoxName = 'weekly_recommendations_box';
  static const String _savedMealsBoxName = 'saved_recommended_meals_box';

  Future<Box<String>> _getBox() async {
    return await HiveService.openBox<String>(_boxName);
  }

  Future<Box<String>> _getRecommendationsBox() async {
    return await HiveService.openBox<String>(_recommendationsBoxName);
  }

  Future<Box<String>> _getSavedMealsBox() async {
    return await HiveService.openBox<String>(_savedMealsBoxName);
  }

  // ==========================================
  // Standard Daily Meals Log
  // ==========================================

  Future<void> saveMeal(MealModel meal) async {
    final box = await _getBox();
    final mealJson = jsonEncode(
      meal.toJson()
        ..['createdAt'] =
            meal.createdAt?.toIso8601String() ??
            DateTime.now().toIso8601String(),
    );
    final id = meal.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(id, mealJson);
  }

  Future<List<MealModel>> getMealsByDate(DateTime date) async {
    final box = await _getBox();
    final allMeals = box.values
        .map((jsonStr) => MealModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    return allMeals.where((meal) {
      if (meal.createdAt == null) return false;
      return meal.createdAt!.year == date.year &&
          meal.createdAt!.month == date.month &&
          meal.createdAt!.day == date.day;
    }).toList();
  }

  // ==========================================
  // Weekly Recommendations Caching
  // ==========================================

  Future<void> saveCachedRecommendations(
    String weekKey,
    List<RecommendedMealModel> meals,
  ) async {
    final box = await _getRecommendationsBox();
    final jsonList = meals.map((m) => m.toJson()).toList();
    await box.put(weekKey, jsonEncode(jsonList));
  }

  Future<List<RecommendedMealModel>?> getCachedRecommendations(
    String weekKey,
  ) async {
    final box = await _getRecommendationsBox();
    final jsonStr = box.get(weekKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;

    try {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      return decoded
          .map((e) => RecommendedMealModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // User Saved/Bookmarked Meals Collection
  // ==========================================

  Future<void> saveRecommendedMeal(RecommendedMealModel meal) async {
    final box = await _getSavedMealsBox();
    // Mark as saved
    final updatedMeal = meal.copyWith(isSaved: true);
    await box.put(updatedMeal.id, jsonEncode(updatedMeal.toJson()));
  }

  Future<void> removeSavedRecommendedMeal(String id) async {
    final box = await _getSavedMealsBox();
    await box.delete(id);
  }

  Future<List<RecommendedMealModel>> getSavedRecommendedMeals() async {
    final box = await _getSavedMealsBox();
    return box.values.map((jsonStr) {
      return RecommendedMealModel.fromJson(jsonDecode(jsonStr)).copyWith(
        isSaved: true,
      );
    }).toList();
  }

  /// Clears all cached weekly recommendations (used to force a fresh API call)
  Future<void> clearAllCachedRecommendations() async {
    final box = await _getRecommendationsBox();
    await box.clear();
  }
}
