import 'package:diamate/features/chat/data/models/chat_message.dart';
import 'package:diamate/features/chat/data/models/chat_session.dart';
import 'package:diamate/features/chat/data/services/chat_local_service.dart';
import 'package:diamate/core/services/chat_companion_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatLocalService _chatLocalService;
  final ChatCompanionService _companionService;

  ChatCubit(this._chatLocalService, this._companionService)
    : super(ChatInitial());

  List<ChatMessage> _messages = [];
  List<ChatSession> _sessions = [];
  ChatSession? _currentSession;
  bool _isTyping = false;

  void loadAllSessions() {
    _sessions = _chatLocalService.getAllSessions();
    _emitSuccess();
  }

  void startNewChat() {
    _messages = [];
    _currentSession = null;
    _emitSuccess();
  }

  void loadSession(ChatSession session) {
    _currentSession = session;
    _messages = List.from(session.messages);
    _emitSuccess();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text, type: MessageType.user);
    _messages.add(userMessage);

    if (_currentSession == null) {
      _currentSession = ChatSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: text.length > 30 ? '${text.substring(0, 30)}...' : text,
        date: DateTime.now(),
        messages: [],
      );
      _sessions.insert(0, _currentSession!);
    }

    _currentSession!.messages.add(userMessage);
    await _chatLocalService.saveSession(_currentSession!);

    _isTyping = true;
    _emitSuccess();

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));

    // For simplicity, we use the "after meal" category for general chat for now,
    // as it's the most common interaction point.
    final aiMessage = ChatMessage(
      text: _companionService.getAfterMealMessage(),
      type: MessageType.ai,
    );
    _messages.add(aiMessage);
    _currentSession!.messages.add(aiMessage);
    await _chatLocalService.saveSession(_currentSession!);

    _isTyping = false;
    _emitSuccess();
  }

  Future<void> sendVoiceMessage(String path) async {
    final userMessage = ChatMessage(
      text: "Voice message",
      type: MessageType.voice,
      audioPath: path,
    );
    _messages.add(userMessage);

    if (_currentSession == null) {
      _currentSession = ChatSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Voice Message",
        date: DateTime.now(),
        messages: [],
      );
      _sessions.insert(0, _currentSession!);
    }

    _currentSession!.messages.add(userMessage);
    await _chatLocalService.saveSession(_currentSession!);

    _isTyping = true;
    _emitSuccess();

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));

    final aiMessage = ChatMessage(
      text: _companionService.getAfterMealMessage(),
      type: MessageType.ai,
    );
    _messages.add(aiMessage);
    _currentSession!.messages.add(aiMessage);
    await _chatLocalService.saveSession(_currentSession!);

    _isTyping = false;
    _emitSuccess();
  }

  Future<void> deleteSession(String sessionId) async {
    await _chatLocalService.deleteSession(sessionId);
    _sessions.removeWhere((s) => s.id == sessionId);
    if (_currentSession?.id == sessionId) {
      _currentSession = null;
      _messages = [];
    }
    _emitSuccess();
  }

  void _emitSuccess() {
    emit(
      ChatSuccess(
        messages: List.from(_messages),
        sessions: List.from(_sessions),
        currentSession: _currentSession,
      ),
    );
  }

  bool get isTyping => _isTyping;
}
