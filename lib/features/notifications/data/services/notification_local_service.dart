import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diamate/core/services/hive/hive_service.dart';

class NotificationLocalService {
  static const String _boxName = 'notifications_box';

  Future<void> init() async {
    HiveService.registerAdapter(PushNotificationModelAdapter());
    await HiveService.openBox<PushNotificationModel>(_boxName);
  }

  Box<PushNotificationModel> get _box =>
      Hive.box<PushNotificationModel>(_boxName);

  Future<void> addNotification(PushNotificationModel notification) async {
    await _box.add(notification);
  }

  List<PushNotificationModel> getAllNotifications() {
    final list = _box.values.toList();
    list.sort((a, b) => b.createAt.compareTo(a.createAt));
    return list;
  }

  Future<void> deleteNotification(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
