import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
enum MessageType {
  @HiveField(0)
  user,
  @HiveField(1)
  ai,
  @HiveField(2)
  loading,
  @HiveField(3)
  voice,
}

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final MessageType type;

  @HiveField(2)
  final String? audioPath;

  ChatMessage({required this.text, required this.type, this.audioPath});
}
