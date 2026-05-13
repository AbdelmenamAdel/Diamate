part of 'recommended_food_cubit.dart';

abstract class RecommendedFoodState extends Equatable {
  const RecommendedFoodState();

  @override
  List<Object?> get props => [];
}

class RecommendedFoodInitial extends RecommendedFoodState {}

class RecommendedFoodLoading extends RecommendedFoodState {}

class RecommendedFoodLoaded extends RecommendedFoodState {
  final List<RecommendedMealModel> recommendations;
  final List<RecommendedMealModel> savedMeals;

  const RecommendedFoodLoaded({
    required this.recommendations,
    required this.savedMeals,
  });

  @override
  List<Object?> get props => [recommendations, savedMeals];
}

class RecommendedFoodError extends RecommendedFoodState {
  final String message;

  const RecommendedFoodError(this.message);

  @override
  List<Object?> get props => [message];
}
