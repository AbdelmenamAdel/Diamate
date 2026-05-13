import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repos/food_repo.dart';
import '../../data/services/food_local_service.dart';
import '../../data/models/recommended_meal_model.dart';

part 'recommended_food_state.dart';

class RecommendedFoodCubit extends Cubit<RecommendedFoodState> {
  final FoodRepo _repo;
  final FoodLocalService _localService;

  RecommendedFoodCubit(this._repo, this._localService)
      : super(RecommendedFoodInitial());

  List<RecommendedMealModel> _cachedRecommendations = [];
  List<RecommendedMealModel> _cachedSavedMeals = [];

  Future<void> loadWeeklyData() async {
    emit(RecommendedFoodLoading());

    // Load saved meals first
    _cachedSavedMeals = await _localService.getSavedRecommendedMeals();
    final savedIds = _cachedSavedMeals.map((e) => e.id).toSet();

    // Fetch recommendations (repo handles weekly cache key internally)
    final result = await _repo.getWeeklyRecommendations();
    result.fold(
      (failure) => emit(RecommendedFoodError(failure)),
      (recommendations) async {
        // If cached data is stale (< 6 meals from old prompt), force re-fetch
        if (recommendations.length < 6) {
          await _localService.clearAllCachedRecommendations();
          final freshResult = await _repo.getWeeklyRecommendations();
          freshResult.fold(
            (failure) => emit(RecommendedFoodError(failure)),
            (freshRecs) {
              _cachedRecommendations = freshRecs.map((m) {
                return m.copyWith(isSaved: savedIds.contains(m.id));
              }).toList();
              emit(RecommendedFoodLoaded(
                recommendations: _cachedRecommendations,
                savedMeals: _cachedSavedMeals,
              ));
            },
          );
          return;
        }

        // Sync saved flag
        _cachedRecommendations = recommendations.map((m) {
          return m.copyWith(isSaved: savedIds.contains(m.id));
        }).toList();

        emit(
          RecommendedFoodLoaded(
            recommendations: _cachedRecommendations,
            savedMeals: _cachedSavedMeals,
          ),
        );
      },
    );
  }

  Future<void> toggleSaveMeal(RecommendedMealModel meal) async {
    if (meal.isSaved) {
      await _localService.removeSavedRecommendedMeal(meal.id);
    } else {
      await _localService.saveRecommendedMeal(meal);
    }

    // Refresh state
    _cachedSavedMeals = await _localService.getSavedRecommendedMeals();
    final savedIds = _cachedSavedMeals.map((e) => e.id).toSet();

    _cachedRecommendations = _cachedRecommendations.map((m) {
      return m.copyWith(isSaved: savedIds.contains(m.id));
    }).toList();

    emit(
      RecommendedFoodLoaded(
        recommendations: _cachedRecommendations,
        savedMeals: _cachedSavedMeals,
      ),
    );
  }

  Future<void> refreshMeals() async {
    emit(RecommendedFoodLoading());
    final result = await _repo.refreshMealsFromWeb();
    result.fold(
      (failure) => emit(RecommendedFoodError(failure)),
      (meals) {
        _cachedRecommendations = meals;
        emit(
          RecommendedFoodLoaded(
            recommendations: _cachedRecommendations,
            savedMeals: _cachedSavedMeals,
          ),
        );
      },
    );
  }
}
