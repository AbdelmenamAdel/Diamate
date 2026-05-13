import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diamate/constant.dart';
import 'package:diamate/features/food/data/models/recommended_meal_model.dart';

class AiEngineService {
  /// General helper to query available AI providers sequentially for abstract JSON tasks
  /// Supports Future expansions like OCR text analysis, Chat diagnostics, and Medical readings
  static Future<Map<String, dynamic>?> requestJsonPayload(
    String prompt, {
    double temperature = 0.3,
  }) async {
    final dio = Dio();

    // ── 1. Gemini API ──
    try {
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${K.geminiApiKey}";
      final res = await dio.post(
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
            "temperature": temperature,
            "responseMimeType": "application/json"
          },
        },
      );
      if (res.statusCode == 200) {
        final text = res.data['candidates'][0]['content']['parts'][0]['text'];
        final clean = text.replaceAll('```json', '').replaceAll('```', '').trim();
        return jsonDecode(clean) as Map<String, dynamic>;
      }
    } catch (e) {
      log("Gemini generic JSON request failed: $e");
    }

    // ── 2. Groq API ──
    try {
      if (K.grokApiKey.isNotEmpty) {
        final res = await dio.post(
          "https://api.groq.com/openai/v1/chat/completions",
          options: Options(headers: {"Authorization": "Bearer ${K.grokApiKey}"}),
          data: {
            "model": "llama3-8b-8192",
            "messages": [
              {"role": "user", "content": prompt}
            ],
            "temperature": temperature,
            "response_format": {"type": "json_object"}
          },
        );
        if (res.statusCode == 200) {
          final text = res.data['choices'][0]['message']['content'];
          final clean = text.replaceAll('```json', '').replaceAll('```', '').trim();
          return jsonDecode(clean) as Map<String, dynamic>;
        }
      }
    } catch (e) {
      log("Groq generic JSON request failed: $e");
    }

    // ── 3. DeepSeek API ──
    try {
      if (K.deepSeekApiKey.isNotEmpty) {
        final res = await dio.post(
          "https://api.deepseek.com/chat/completions",
          options: Options(headers: {"Authorization": "Bearer ${K.deepSeekApiKey}"}),
          data: {
            "model": "deepseek-chat",
            "messages": [
              {"role": "user", "content": prompt}
            ],
            "temperature": temperature,
            "response_format": {"type": "json_object"}
          },
        );
        if (res.statusCode == 200) {
          final text = res.data['choices'][0]['message']['content'];
          final clean = text.replaceAll('```json', '').replaceAll('```', '').trim();
          return jsonDecode(clean) as Map<String, dynamic>;
        }
      }
    } catch (e) {
      log("DeepSeek generic JSON request failed: $e");
    }

    return null;
  }

  /// Translates a single meal's title, ingredients, and steps to Arabic via Multi-Provider AI Pipeline
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

    // Execute Multi-Provider Pipeline via generic engine helper
    final payload = await requestJsonPayload(prompt);

    if (payload != null) {
      final tTitle = payload['title']?.toString() ?? meal.title;
      final tIngs = (payload['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          meal.ingredients;
      final tSteps = (payload['preparationSteps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          meal.preparationSteps;

      return meal.copyWith(
        titleAr: tTitle.isNotEmpty ? tTitle : meal.title,
        ingredientsAr: tIngs.isNotEmpty ? tIngs : meal.ingredients,
        preparationStepsAr: tSteps.isNotEmpty ? tSteps : meal.preparationSteps,
      );
    }

    // ── Ultimate Local Fallback (Smart Substring Dictionary) ──
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

  /// Multi-Modal Vision analysis to read glucose meter values directly from image pixels
  static Future<Map<String, dynamic>?> analyzeGlucoseImage(
    File imageFile,
  ) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final dio = Dio();
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${K.geminiApiKey}";

      final res = await dio.post(
        url,
        data: {
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Analyze this digital display of a glucose meter. Ensure it's a real device and extract the primary integer reading in mg/dL. Return ONLY a valid JSON object: {\"reading\": 102}"
                },
                {
                  "inlineData": {
                    "mimeType": "image/jpeg",
                    "data": base64Image,
                  }
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.1,
            "responseMimeType": "application/json",
          },
        },
      );

      if (res.statusCode == 200) {
        final text = res.data['candidates'][0]['content']['parts'][0]['text'];
        final clean =
            text.replaceAll('```json', '').replaceAll('```', '').trim();
        return jsonDecode(clean) as Map<String, dynamic>;
      }
    } catch (e) {
      log("Gemini Vision image analysis warning: $e");
    }
    return null;
  }
}
