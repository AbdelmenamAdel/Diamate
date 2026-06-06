import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:diamate/features/dfu_test/data/models/dfu_prediction_response.dart';

class DfuRemoteService {
  final Dio _dio;

  DfuRemoteService(this._dio);

  String get _baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    } else {
      return 'http://127.0.0.1:5000';
    }
  }

  Future<DfuPredictionResponse> predictDfu(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _dio.post(
        '$_baseUrl/api/v1/segmentation/',
        data: {
          'image_b64': base64Image,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return DfuPredictionResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data['signal'] ?? e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
