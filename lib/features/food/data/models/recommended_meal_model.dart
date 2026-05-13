import 'package:equatable/equatable.dart';

class RecommendedMealModel extends Equatable {
  final String id;
  final String title;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final String description;
  final List<String> preparationSteps;
  final List<String> ingredients;
  final bool isSaved;
  final String? imageUrl; // Real meal image from TheMealDB

  const RecommendedMealModel({
    required this.id,
    required this.title,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.description,
    required this.preparationSteps,
    required this.ingredients,
    this.isSaved = false,
    this.imageUrl,
  });

  RecommendedMealModel copyWith({
    String? id,
    String? title,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    String? description,
    List<String>? preparationSteps,
    List<String>? ingredients,
    bool? isSaved,
    String? imageUrl,
  }) {
    return RecommendedMealModel(
      id: id ?? this.id,
      title: title ?? this.title,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      description: description ?? this.description,
      preparationSteps: preparationSteps ?? this.preparationSteps,
      ingredients: ingredients ?? this.ingredients,
      isSaved: isSaved ?? this.isSaved,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'description': description,
      'preparationSteps': preparationSteps,
      'ingredients': ingredients,
      'isSaved': isSaved,
      'imageUrl': imageUrl,
    };
  }

  factory RecommendedMealModel.fromJson(Map<String, dynamic> json) {
    return RecommendedMealModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      preparationSteps: (json['preparationSteps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isSaved: json['isSaved'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        calories,
        protein,
        carbs,
        fats,
        description,
        preparationSteps,
        ingredients,
        isSaved,
        imageUrl,
      ];
}
