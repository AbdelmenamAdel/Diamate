part of 'food_cubit.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodAnalysisLoading extends FoodState {}

class FoodAnalysisSuccess extends FoodState {
  final List<String> ingredients;

  const FoodAnalysisSuccess({required this.ingredients});

  @override
  List<Object?> get props => [ingredients];
}

class FoodSuccess extends FoodState {
  final NutritionModel? nutrition;

  const FoodSuccess({this.nutrition});

  @override
  List<Object?> get props => [nutrition];
}

class FoodError extends FoodState {
  final String message;

  const FoodError({required this.message});

  @override
  List<Object?> get props => [message];
}
