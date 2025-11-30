import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'dart:io';

Future<void> analyzeImage(File imageFile) async {
  final apiKey = 'AIzaSyAXhUoLueIID4NsrS6t15M6-lcPWi6LkhU'; // 🔑 paste here
  final endpoint =
      'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

  final bytes = imageFile.readAsBytesSync();
  final base64Image = base64Encode(bytes);
  final dio = Dio();
  final body = jsonEncode({
    "requests": [
      {
        "image": {"content": base64Image},
        "features": [
          {"type": "LABEL_DETECTION", "maxResults": 5},
        ],
      },
    ],
  });

  final response = await dio.post(
    endpoint,
    options: Options(headers: {"Content-Type": "application/json"}),
    data: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.data);
    log(data["responses"][0]["labelAnnotations"]);
  } else {
    log("Error: ${response.statusCode}");
  }
}

Future<Map<String, dynamic>?> getNutrition(String foodName) async {
  final usdaApiKey = 'ldxfIgPleYdzv5rPlZ3g51xlaoARvOegoSTekAWA';
  final dio = Dio();

  const url = 'https://api.nal.usda.gov/fdc/v1/foods/search';

  try {
    final response = await dio.get(
      url,
      queryParameters: {
        'query': foodName,
        'api_key': usdaApiKey,
        'pageSize': 1,
      },
    );

    if (response.statusCode == 200) {
      final foods = response.data['foods'];
      if (foods != null && foods.isNotEmpty) {
        final nutrients = List<Map<String, dynamic>>.from(
          foods[0]['foodNutrients'] ?? [],
        );

        Map<String, dynamic> findNutrient(String name) {
          return nutrients.firstWhere(
            (n) => n['nutrientName'] == name,
            orElse: () => {},
          );
        }

        final energy = findNutrient('Energy');
        final protein = findNutrient('Protein');
        final carbs = findNutrient('Carbohydrate, by difference');
        final fat = findNutrient('Total lipid (fat)');

        return {
          "name": foods[0]['description'],
          "calories": energy['value'] ?? 0,
          "protein": protein['value'] ?? 0,
          "carbs": carbs['value'] ?? 0,
          "fat": fat['value'] ?? 0,
        };
      }
    }
  } catch (e) {
    log("Error fetching nutrition data: $e");
  }

  return null;
}
