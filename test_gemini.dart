import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyBrh2OI-lZgOpj3DaasF1EPg0kR9isZWAY"; // Key from constant.dart

  // create a dummy 1x1 jpeg base64
  final base64Image = "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////wgALCAABAAEBAREA/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxA=";

  final prompt = '''
Analyze this food image and list the main visible ingredients.
Return ONLY a valid JSON array of strings, for example: ["Chicken", "Rice", "Tomato"].
Do not include any other text or markdown formatting.
''';

  try {
    final response = await dio.post(
      url,
      data: {
        "contents": [{
          "parts": [
            {"text": prompt},
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64Image
              }
            }
          ]
        }],
        "generationConfig": {
          "temperature": 0.4,
          "responseMimeType": "application/json"
        }
      },
    );
    print(response.data);
  } catch(e) {
    if (e is DioException) {
      print(e.response?.data);
    } else {
      print(e);
    }
  }
}
