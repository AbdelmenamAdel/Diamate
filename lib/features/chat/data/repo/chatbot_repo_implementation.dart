import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/error/exception.dart';
import 'package:diamate/features/chat/data/models/chatbot_q_response_model.dart';
import 'package:diamate/features/chat/domain/repo/chatbot_repo.dart';
import 'package:dio/dio.dart';

class ChatbotRepoImplementation implements ChatbotRepo {
  final ApiConsumer api;

  ChatbotRepoImplementation({required this.api});

  @override
  Future<Either<String, ChatbotQResponseModel>> sendMessage({
    required String sessionID,
    required String question,
  }) async {
    try {
      final response = await api.post(
        // EndPoint.chatBotSendMessage,
        "http://localhost:8000/${EndPoint.chatBotSendMessage}/",
        data: {Apikeys.sessionId: sessionID, Apikeys.question: question},
      );

      // Handle error response from backend (e.g. 429 rate limit)
      if (response is Map<String, dynamic> && response.containsKey('error')) {
        final error = response['error'];
        log(error.toString());
        final message = error is Map
            ? error['message']?.toString() ?? 'Unknown error'
            : error.toString();
        return left(message);
      }

      final res = ChatbotQResponseModel.fromJson(response);
      if (res.signal != "Chat Response Generated Successfully") {
        return left(res.signal);
      }
      return right(res);
    } on ServerFailure catch (e) {
      // DioException wrapped by handleDioException — extract Signal from response
      return left(_extractServerError(e));
    } on DioException catch (e) {
      return left(_extractDioError(e));
    } catch (e) {
      return left(_parseErrorMessage(e));
    }
  }

  String _extractServerError(ServerFailure e) {
    // The errorModel.errorMessage defaults to "User not authenticated" 
    // because Failure.fromJson looks for 'title' key which doesn't exist
    // in our chat API response. We return a generic failure message instead.
    return 'Failed to generate response. Please try again.';
  }

  String _extractDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      // Check for Signal field (chat API error format)
      if (data.containsKey('Signal')) {
        return data['Signal'].toString();
      }
      // Check for error field (Gemini API error format)
      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is Map && error.containsKey('message')) {
          return _parseErrorMessage(error['message']);
        }
      }
    }
    return _parseErrorMessage(e);
  }

  String _parseErrorMessage(dynamic error) {
    final errorStr = error.toString();
    // Extract a user-friendly message for common errors
    if (errorStr.contains('RESOURCE_EXHAUSTED') || errorStr.contains('429')) {
      return 'You have exceeded the rate limit. Please wait a moment and try again.';
    }
    if (errorStr.contains('SocketException') ||
        errorStr.contains('Connection refused')) {
      return 'Unable to connect to the server. Please check your connection.';
    }
    return errorStr;
  }
}
