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
  final String? imageUrl;        // primary image (for cards)
  final List<String> imageUrls; // all images (for details view carousel)

  // ── Localized Arabic Fields (Optional) ──
  final String? titleAr;
  final String? descriptionAr;
  final List<String>? preparationStepsAr;
  final List<String>? ingredientsAr;

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
    this.imageUrls = const [],
    this.titleAr,
    this.descriptionAr,
    this.preparationStepsAr,
    this.ingredientsAr,
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
    List<String>? imageUrls,
    String? titleAr,
    String? descriptionAr,
    List<String>? preparationStepsAr,
    List<String>? ingredientsAr,
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
      imageUrls: imageUrls ?? this.imageUrls,
      titleAr: titleAr ?? this.titleAr,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      preparationStepsAr: preparationStepsAr ?? this.preparationStepsAr,
      ingredientsAr: ingredientsAr ?? this.ingredientsAr,
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
      'imageUrls': imageUrls,
      'titleAr': titleAr,
      'descriptionAr': descriptionAr,
      'preparationStepsAr': preparationStepsAr,
      'ingredientsAr': ingredientsAr,
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
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      titleAr: json['titleAr'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      preparationStepsAr: (json['preparationStepsAr'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      ingredientsAr: (json['ingredientsAr'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
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
        imageUrls,
        titleAr,
        descriptionAr,
        preparationStepsAr,
        ingredientsAr,
      ];

  // ── Helper Getters for instant UI dynamic toggle ──
  String displayTitle(bool isArabic) =>
      isArabic ? (titleAr ?? title) : title;

  String displayDescription(bool isArabic) =>
      isArabic ? (descriptionAr ?? description) : description;

  List<String> displayIngredients(bool isArabic) {
    final list = isArabic ? (ingredientsAr ?? ingredients) : ingredients;
    if (!isArabic) return list;

    // Real-time Runtime Cleaner to strip legacy cached tags and translate keywords dynamically
    String cleanIng(String item) {
      String res = item.replaceAll('(مكون طبيعي)', '').trim();
      final lower = res.toLowerCase();
      if (lower.contains('olive oil')) {
        res = res.replaceAll(RegExp('olive oil', caseSensitive: false), 'زيت زيتون');
      }
      if (lower.contains('lemon juice')) {
        res = res.replaceAll(RegExp('lemon juice', caseSensitive: false), 'عصير ليمون');
      }
      if (lower.contains('garlic')) {
        res = res.replaceAll(RegExp('garlic clove|garlic', caseSensitive: false), 'ثوم');
      }
      if (lower.contains('tomato')) {
        res = res.replaceAll(RegExp('tomato puree|tomato', caseSensitive: false), 'طماطم');
      }
      if (lower.contains('cumin')) {
        res = res.replaceAll(RegExp('cumin', caseSensitive: false), 'كمون');
      }
      if (lower.contains('yogurt')) {
        res = res.replaceAll(RegExp('greek yogurt|yogurt', caseSensitive: false), 'زبادي صحي');
      }
      if (lower.contains('pepper')) {
        res = res.replaceAll(RegExp('cayenne pepper|black pepper|pepper', caseSensitive: false), 'فلفل');
      }
      if (lower.contains('bread')) {
        res = res.replaceAll(RegExp('pita bread|bread', caseSensitive: false), 'خبز أسمر');
      }
      if (lower.contains('lettuce')) {
        res = res.replaceAll(RegExp('lettuce', caseSensitive: false), 'خس');
      }
      if (lower.contains('rice')) {
        res = res.replaceAll(RegExp('rice', caseSensitive: false), 'أرز بسمتي مسلوق');
      }
      if (lower.contains('noodles')) {
        res = res.replaceAll(RegExp('noodles', caseSensitive: false), 'مكرونة شوفان');
      }
      if (lower.contains('butter')) {
        res = res.replaceAll(RegExp('butter', caseSensitive: false), 'زبدة طبيعية');
      }
      if (lower.contains('vinegar')) {
        res = res.replaceAll(RegExp('white wine vinegar|vinegar', caseSensitive: false), 'خل');
      }
      if (lower.contains('salt')) {
        res = res.replaceAll(RegExp('salt', caseSensitive: false), 'ملح بحري');
      }
      return res;
    }

    return list.map((e) => cleanIng(e)).toList();
  }

  List<String> displaySteps(bool isArabic) {
    final list =
        isArabic ? (preparationStepsAr ?? preparationSteps) : preparationSteps;
    if (!isArabic) return list;

    // If reading from legacy cache with repetitive fixed steps, dynamicize them based on meal context
    if (list.isNotEmpty && list.first.contains('تُغسل المكونات')) {
      final t = titleAr ?? title;
      final isSoup = t.toLowerCase().contains('soup') ||
          t.toLowerCase().contains('puree');
      return [
        "تُجهز مكونات ($t) وتُغسل جيداً بالماء النقي.",
        isSoup
            ? "تُخلط المكونات وتُطهى على نار هادئة حتى يتجانس القوام بالكامل."
            : "تُتبل المكونات بقليل من زيت الزيتون والبهارات وتُشوى في الفرن لتقليل السعرات.",
        "تُقدم الوجبة دافئة ومثالية جداً للحفاظ على استقرار مستوى السكر في الدم."
      ];
    }
    return list;
  }
}
