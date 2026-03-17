import 'package:dartz/dartz.dart';
import 'package:diamate/core/database/api/api_consumer.dart';
import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/features/chat/data/models/chatbot_q_response_model.dart';
import 'package:diamate/features/chat/domain/repo/chatbot_repo.dart';

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
      final res = ChatbotQResponseModel.fromJson(response);
      if (res.signal != "Chat Response Generated Successfully") {
        return left(res.signal);
      }
      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }
}
