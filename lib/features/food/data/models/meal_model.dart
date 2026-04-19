import 'package:equatable/equatable.dart';

class IngredientModel extends Equatable {
  final String name;
  final double quantityGrams;

  const IngredientModel({
    required this.name,
    required this.quantityGrams,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantityGrams': quantityGrams,
    };
  }

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] as String,
      quantityGrams: (json['quantityGrams'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [name, quantityGrams];
}

class MealModel extends Equatable {
  final String? id;
  final String name;
  final String? imagePath;
  final List<IngredientModel> ingredients;
  final NutritionModel? nutrition;
  final DateTime? createdAt;

  const MealModel({
    this.id,
    required this.name,
    this.imagePath,
    required this.ingredients,
    this.nutrition,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
    };
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id']?.toString(),
      name: json['name'] as String,
      imagePath: json['imagePath'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((i) => IngredientModel.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      nutrition: json['nutrition'] != null
          ? NutritionModel.fromJson(json['nutrition'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, imagePath, ingredients, nutrition, createdAt];
}

class NutritionModel extends Equatable {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const NutritionModel({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [calories, protein, fat, carbs];
}
