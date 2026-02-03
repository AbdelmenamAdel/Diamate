part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<ChatMessage> messages;
  final List<ChatSession> sessions;
  final ChatSession? currentSession;

  ChatSuccess({
    required this.messages,
    required this.sessions,
    this.currentSession,
  });
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
