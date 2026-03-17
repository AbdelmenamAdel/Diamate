import 'package:dartz/dartz.dart';
import 'package:diamate/features/chat/data/models/chatbot_q_response_model.dart';

abstract class ChatbotRepo {
  Future<Either<String, ChatbotQResponseModel>> sendMessage({
    required String sessionID,
    required String question,
  });
}
