import 'dart:developer';

import 'package:diamate/play/usda_test.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FoodAnalyzerScreen());
  }
}

// Flutter screen: Camera -> Upload -> Google Vision -> Show Results (using Dio)
// Usage:
// 1) Add to pubspec.yaml:
//    dependencies:
//      flutter:
//        sdk: flutter
//      image_picker: ^0.8.7+4
//      dio: ^5.3.2
//
// 2) Android permissions (android/app/src/main/AndroidManifest.xml):
//    <uses-permission android:name="android.permission.INTERNET" />
//    <uses-permission android:name="android.permission.CAMERA" />
//
// 3) iOS (ios/Runner/Info.plist):
//    <key>NSCameraUsageDescription</key>
//    <string>We need to use the camera to take food photos</string>
//    <key>NSPhotoLibraryUsageDescription</key>
//    <string>We need access to save/select photos</string>
//
// 4) Enable Vision API in Google Cloud Console and create an API key.
//    Replace `YOUR_API_KEY` below with the real key.

class FoodAnalyzerScreen extends StatefulWidget {
  const FoodAnalyzerScreen({super.key});

  @override
  State<FoodAnalyzerScreen> createState() => _FoodAnalyzerScreenState();
}

class _FoodAnalyzerScreenState extends State<FoodAnalyzerScreen> {
  File? _imageFile;
  bool _loading = false;
  String? _error;
  List<LabelResult> _labels = [];

  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  static const String _apiKey = 'AIzaSyAXhUoLueIID4NsrS6t15M6-lcPWi6LkhU';
  Future<void> _analyzeImage(File imageFile) async {
    setState(() {
      _loading = true;
      _error = null;
      _labels = [];
    });

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final body = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [
              {'type': 'LABEL_DETECTION', 'maxResults': 10},
            ],
          },
        ],
      };

      final response = await _dio.post(
        'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final responses = data['responses'] as List<dynamic>?;
        if (responses == null || responses.isEmpty) {
          setState(() => _error = 'No response from Vision API.');
        } else {
          final first = responses[0] as Map<String, dynamic>;
          final annotations = first['labelAnnotations'] as List<dynamic>?;
          if (annotations == null || annotations.isEmpty) {
            setState(() => _error = 'No labels found.');
          } else {
            final parsed = annotations.map((a) {
              final desc = a['description'] as String? ?? '';
              final score = (a['score'] as num?)?.toDouble() ?? 0.0;
              return LabelResult(description: desc, score: score);
            }).toList();

            setState(() => _labels = parsed);
          }
        }
      } else {
        setState(
          () => _error =
              'Vision API error ${response.statusCode}: ${response.statusMessage}',
        );
      }
    } catch (e) {
      setState(() => _error = 'Failed to analyze image: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (picked == null) return;
      setState(() {
        _imageFile = File(picked.path);
        _labels = [];
        _error = null;
      });
      await _analyzeImage(_imageFile!);
    } catch (e) {
      setState(() => _error = 'Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Analyzer (Vision API)'),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return const FoodAnalyzerScreen2();
                  },
                ),
              );
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _loading ? null : _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: Text(_loading ? 'Processing...' : 'Take Photo'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? const Center(
                          child: Text('No image yet. Tap "Take Photo"'),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(flex: 2, child: _buildResultsArea()),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      log(_error!);
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_labels.isEmpty) {
      return const Center(child: Text('No analysis results yet.'));
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        final label = _labels[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${(label.score * 100).toStringAsFixed(0)}%'),
          ),
          title: Text(label.description),
          subtitle: Text('Confidence: ${label.score.toStringAsFixed(3)}'),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: _labels.length,
    );
  }
}

class LabelResult {
  final String description;
  final double score;

  LabelResult({required this.description, required this.score});
}
