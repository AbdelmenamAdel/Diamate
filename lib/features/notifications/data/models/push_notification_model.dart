import 'package:hive/hive.dart';
part 'push_notification_model.g.dart';

@HiveType(typeId: 3)
class PushNotificationModel extends HiveObject {
  PushNotificationModel({
    required this.title,
    required this.body,
    required this.productId,
    required this.createAt,
    this.isRead = false,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  @HiveField(2)
  String productId;

  @HiveField(3)
  final DateTime createAt;

  @HiveField(4)
  bool isRead;
}
