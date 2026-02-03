import 'package:diamate/features/chat/data/models/chat_message.dart';
import 'package:diamate/features/chat/data/models/chat_session.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatLocalService {
  static const String _sessionBoxName = 'chat_sessions';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MessageTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ChatSessionAdapter());
    }

    await Hive.openBox<ChatSession>(_sessionBoxName);
  }

  Box<ChatSession> get _sessionBox => Hive.box<ChatSession>(_sessionBoxName);

  Future<void> saveSession(ChatSession session) async {
    await _sessionBox.put(session.id, session);
  }

  List<ChatSession> getAllSessions() {
    final sessions = _sessionBox.values.toList();
    // Sort by date descending
    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  Future<void> deleteSession(String id) async {
    await _sessionBox.delete(id);
  }

  Future<void> clearAll() async {
    await _sessionBox.clear();
  }
}
