import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class FoodAnalyzerScreen2 extends StatefulWidget {
  const FoodAnalyzerScreen2({super.key});

  @override
  State<FoodAnalyzerScreen2> createState() => _FoodAnalyzerScreen2State();
}

class _FoodAnalyzerScreen2State extends State<FoodAnalyzerScreen2> {
  File? _image;
  bool _isLoading = false;
  List<dynamic> _labels = [];
  Map<String, dynamic>? _nutrition;

  final _picker = ImagePicker();
  final _dio = Dio();
  final String _visionApiKey = 'YOUR_GOOGLE_VISION_API_KEY_HERE'; // 🔑

  // 🔹 Fake Vision data (to simulate when Vision API fails)
  final Map<String, dynamic> fakeVision = {
    "responses": [
      {
        "labelAnnotations": [
          {
            "mid": "/m/01yrx",
            "description": "Pizza",
            "score": 0.98,
            "topicality": 0.98,
          },
          {
            "mid": "/m/0bt9lr",
            "description": "Food",
            "score": 0.95,
            "topicality": 0.95,
          },
        ],
      },
    ],
  };

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _labels = [];
        _nutrition = null;
      });
      await _analyzeImage(_image!);
    }
  }

  Future<void> _analyzeImage(File image) async {
    setState(() => _isLoading = true);
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final url =
          'https://vision.googleapis.com/v1/images:annotate?key=$_visionApiKey';

      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "requests": [
            {
              "image": {"content": base64Image},
              "features": [
                {"type": "LABEL_DETECTION", "maxResults": 5},
              ],
            },
          ],
        },
      );

      // 🔹 If Vision API worked
      if (response.statusCode == 200 &&
          response.data['responses']?[0]?['labelAnnotations'] != null) {
        final labels = response.data['responses'][0]['labelAnnotations'];
        setState(() => _labels = labels);
        log("✅ Vision API returned ${labels.length} labels");
      } else {
        // 🔹 Vision API failed → use fake data
        setState(
          () => _labels = fakeVision['responses'][0]['labelAnnotations'],
        );
        log("⚠️ Using fake Vision data instead");
      }

      // 🔹 Extract top label to send to USDA
      final topLabel = _labels.isNotEmpty
          ? _labels[0]['description']
          : "Unknown food";
      log('🔍 Food Detected: $topLabel');

      // 🔹 Call USDA for real nutrition info
      final nutrition = await getNutrition(topLabel);
      setState(() => _nutrition = nutrition);
    } catch (e) {
      log('⚠️ Vision API error: $e');
      // 🔹 Fallback: use fake Vision
      setState(() => _labels = fakeVision['responses'][0]['labelAnnotations']);

      final topLabel = _labels[0]['description'];
      log('🔄 Fallback food: $topLabel');

      // 🔹 Still get real USDA nutrition
      final nutrition = await getNutrition(topLabel);
      setState(() => _nutrition = nutrition);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔹 Replace with your real USDA fetch function
  Future<Map<String, dynamic>> getNutrition(String foodName) async {
    // Example fake call until USDA integration is done
    await Future.delayed(const Duration(seconds: 1));
    return {
      "name": foodName,
      "calories": 266,
      "protein": 11,
      "carbs": 33,
      "fat": 10,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Analyzer 🍽️")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_image!, height: 200),
              ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_nutrition != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _nutrition!['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("🔥 Calories: ${_nutrition!['calories']} kcal"),
                      Text("💪 Protein: ${_nutrition!['protein']} g"),
                      Text("🍞 Carbs: ${_nutrition!['carbs']} g"),
                      Text("🥑 Fat: ${_nutrition!['fat']} g"),
                    ],
                  ),
                ),
              )
            else if (_labels.isNotEmpty)
              Text("Detected: ${_labels[0]['description']}"),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await getNutrition("banana");
                log("Nutrition data: $result");
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Food"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
