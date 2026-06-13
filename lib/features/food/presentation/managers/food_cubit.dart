import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/managers/auth/auth_cubit.dart';
import '../../data/models/meal_model.dart';
import '../../domain/repos/food_repo.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepo _foodRepo;
  final AuthCubit _authCubit;

  FoodCubit(this._foodRepo, this._authCubit) : super(FoodInitial());

  final Map<DateTime, List<MealModel>> _mealsCache = {};
  DateTime _selectedDate = DateTime.now();

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> loadMealsForDate(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    _selectedDate = normalizedDate;

    if (_mealsCache.containsKey(normalizedDate)) {
      emit(
        FoodHistoryLoaded(
          meals: Map.from(_mealsCache),
          selectedDate: _selectedDate,
        ),
      );
      return;
    }

    emit(FoodHistoryLoading());
    final result = await _foodRepo.getMealsByDate(normalizedDate);
    result.fold((failure) => emit(FoodError(message: failure)), (meals) {
      _mealsCache[normalizedDate] = meals;
      emit(
        FoodHistoryLoaded(
          meals: Map.from(_mealsCache),
          selectedDate: _selectedDate,
        ),
      );
    });
  }

  Future<void> analyzeImage(File image) async {
    emit(FoodAnalysisLoading());
    final result = await _foodRepo.analyzeFoodImage(image);
    result.fold(
      (failure) => emit(FoodError(message: failure)),
      (ingredients) => emit(FoodAnalysisSuccess(ingredients: ingredients)),
    );
  }

  Future<void> addMeal({
    required String name,
    required List<IngredientModel> ingredients,
    String? imagePath,
  }) async {
    if (_authCubit.user?.id == null) {
      emit(const FoodError(message: "User not authenticated"));
      return;
    }

    emit(FoodLoading());

    final meal = MealModel(
      name: name,
      ingredients: ingredients,
      imagePath: imagePath,
    );

    final result = await _foodRepo.addFoodMeal(
      meal: meal,
      patientId: int.parse(_authCubit.user!.id.toString()),
    );

    result.fold(
      (failure) => emit(FoodError(message: failure)),
      (nutrition) {
        // Clear the cache for today so that the app fetches the new meal when navigating back to Home
        _mealsCache.remove(_normalizeDate(DateTime.now()));
        emit(FoodSuccess(nutrition: nutrition));
        // Automatically fetch the updated meals for today so the Dashboard updates
        loadMealsForDate(DateTime.now());
      },
    );
  }
  List<MealModel> searchCachedMeals(String query) {
    if (query.trim().isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    final List<MealModel> results = [];
    
    for (final dayMeals in _mealsCache.values) {
      for (final meal in dayMeals) {
        if (meal.name.toLowerCase().contains(lowerQuery)) {
          results.add(meal);
        } else if (meal.ingredients.any((i) => i.name.toLowerCase().contains(lowerQuery))) {
          results.add(meal);
        }
      }
    }
    
    return results.toSet().toList(); // Remove duplicates if any
  }
}
