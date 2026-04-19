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
      (nutrition) => emit(FoodSuccess(nutrition: nutrition)),
    );
  }
}
