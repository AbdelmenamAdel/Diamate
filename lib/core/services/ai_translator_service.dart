import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:diamate/constant.dart';
import 'package:diamate/features/food/data/models/recommended_meal_model.dart';

class AiTranslatorService {
  /// Translates a single meal's title, ingredients, and steps to Arabic via Multi-Provider AI Pipeline
  /// Sequential Provider Switching: Gemini -> Groq -> DeepSeek -> Local Fallback Dictionary
  static Future<RecommendedMealModel> translateMeal(
    RecommendedMealModel meal,
    Dio dio,
  ) async {
    final prompt = '''
Translate and adapt the following Egyptian recipe to make it perfectly optimized for a diabetic diet app.
Give it an appealing Egyptian Arabic title (e.g., add "صحي" or "دايت").
Break down the instructions into 3-5 concise preparation steps in Egyptian Arabic, explicitly suggesting healthy methods (like baking instead of deep-frying, using olive oil, or reducing simple carbs).
Return ONLY a valid JSON object with the exact keys below, without markdown formatting or extra text:

Original Title: "${meal.title}"
Original Ingredients: ${jsonEncode(meal.ingredients)}
Original Steps: ${jsonEncode(meal.preparationSteps)}

Target JSON Output Structure:
{
  "title": "اسم الوجبة بالمصري",
  "ingredients": ["المكون الأول بالعربي", "المكون الثاني بالعربي"],
  "preparationSteps": ["الخطوة الأولى بالعربي", "الخطوة الثانية بالعربي"]
}
''';

    // ── 1. PRIMARY PROVIDER: Gemini 2.5 Flash ──
    try {
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${K.geminiApiKey}";
      final response = await dio.post(
        url,
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.3,
            "responseMimeType": "application/json"
          },
        },
      );

      if (response.statusCode == 200) {
        final text =
            response.data['candidates'][0]['content']['parts'][0]['text'];
        final cleanText =
            text.replaceAll('```json', '').replaceAll('```', '').trim();
        final resJson = jsonDecode(cleanText) as Map<String, dynamic>;

        final tTitle = resJson['title']?.toString() ?? meal.title;
        final tIngs = (resJson['ingredients'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            meal.ingredients;
        final tSteps = (resJson['preparationSteps'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            meal.preparationSteps;

        return meal.copyWith(
          titleAr: tTitle.isNotEmpty ? tTitle : meal.title,
          ingredientsAr: tIngs.isNotEmpty ? tIngs : meal.ingredients,
          preparationStepsAr:
              tSteps.isNotEmpty ? tSteps : meal.preparationSteps,
        );
      }
    } catch (e) {
      log('Gemini translation failed for meal ${meal.id}, falling back to Groq API... Error: $e');
    }

    // ── 2. BACKUP PROVIDER 1: Groq API (Super fast inference) ──
    try {
      if (K.grokApiKey.isNotEmpty) {
        final response = await dio.post(
          "https://api.groq.com/openai/v1/chat/completions",
          options: Options(
            headers: {"Authorization": "Bearer ${K.grokApiKey}"},
          ),
          data: {
            "model": "llama3-8b-8192",
            "messages": [
              {"role": "user", "content": prompt}
            ],
            "temperature": 0.3,
            "response_format": {"type": "json_object"}
          },
        );

        if (response.statusCode == 200) {
          final text = response.data['choices'][0]['message']['content'];
          final cleanText =
              text.replaceAll('```json', '').replaceAll('```', '').trim();
          final resJson = jsonDecode(cleanText) as Map<String, dynamic>;

          final tTitle = resJson['title']?.toString() ?? meal.title;
          final tIngs = (resJson['ingredients'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              meal.ingredients;
          final tSteps = (resJson['preparationSteps'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              meal.preparationSteps;

          return meal.copyWith(
            titleAr: tTitle.isNotEmpty ? tTitle : meal.title,
            ingredientsAr: tIngs.isNotEmpty ? tIngs : meal.ingredients,
            preparationStepsAr:
                tSteps.isNotEmpty ? tSteps : meal.preparationSteps,
          );
        }
      }
    } catch (e) {
      log('Groq translation failed for meal ${meal.id}, falling back to DeepSeek API... Error: $e');
    }

    // ── 3. BACKUP PROVIDER 2: DeepSeek API ──
    try {
      if (K.deepSeekApiKey.isNotEmpty) {
        final response = await dio.post(
          "https://api.deepseek.com/chat/completions",
          options: Options(
            headers: {"Authorization": "Bearer ${K.deepSeekApiKey}"},
          ),
          data: {
            "model": "deepseek-chat",
            "messages": [
              {"role": "user", "content": prompt}
            ],
            "temperature": 0.3,
            "response_format": {"type": "json_object"}
          },
        );

        if (response.statusCode == 200) {
          final text = response.data['choices'][0]['message']['content'];
          final cleanText =
              text.replaceAll('```json', '').replaceAll('```', '').trim();
          final resJson = jsonDecode(cleanText) as Map<String, dynamic>;

          final tTitle = resJson['title']?.toString() ?? meal.title;
          final tIngs = (resJson['ingredients'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              meal.ingredients;
          final tSteps = (resJson['preparationSteps'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              meal.preparationSteps;

          return meal.copyWith(
            titleAr: tTitle.isNotEmpty ? tTitle : meal.title,
            ingredientsAr: tIngs.isNotEmpty ? tIngs : meal.ingredients,
            preparationStepsAr:
                tSteps.isNotEmpty ? tSteps : meal.preparationSteps,
          );
        }
      }
    } catch (e) {
      log('DeepSeek translation failed for meal ${meal.id}, falling back to Local Smart Dictionary... Error: $e');
    }

    // ── 4. ULTIMATE LOCAL FALLBACK (Smart Substring Dictionary) ──
    String translateIng(String ing) {
      final lower = ing.toLowerCase();
      String res = ing;
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
        res = res.replaceAll(RegExp('tomato', caseSensitive: false), 'طماطم');
      }
      if (lower.contains('cumin')) {
        res = res.replaceAll(RegExp('cumin', caseSensitive: false), 'كمون');
      }
      if (lower.contains('yogurt')) {
        res = res.replaceAll(RegExp('greek yogurt|yogurt', caseSensitive: false), 'زبادي صحي');
      }
      if (lower.contains('pepper')) {
        res = res.replaceAll(RegExp('cayenne pepper|black pepper', caseSensitive: false), 'فلفل');
      }
      if (lower.contains('bread')) {
        res = res.replaceAll(RegExp('pita bread|bread', caseSensitive: false), 'خبز أسمر');
      }
      if (lower.contains('lettuce')) {
        res = res.replaceAll(RegExp('lettuce', caseSensitive: false), 'خس طازج');
      }
      if (lower.contains('paprika')) {
        res = res.replaceAll(RegExp('paprika', caseSensitive: false), 'بابريكا');
      }
      return res;
    }

    return meal.copyWith(
      titleAr: meal.title.contains('Meal') ? "وجبة مصرية صحية" : meal.title,
      ingredientsAr: meal.ingredients.map((e) => translateIng(e)).toList(),
      preparationStepsAr: [
        "تُغسل المكونات جيداً بالماء النقي.",
        "تُحضر وتُطهى على حرارة متوسطة للحفاظ على القيم الغذائية.",
        "تُقدم دافئة ومناسبة تماماً للنظام الغذائي لمرضى السكري."
      ],
    );
  }
}
