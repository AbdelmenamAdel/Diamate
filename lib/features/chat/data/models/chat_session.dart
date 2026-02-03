import 'package:diamate/features/chat/data/models/chat_message.dart';
import 'package:hive/hive.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 2)
class ChatSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.date,
    required this.messages,
  });
}
