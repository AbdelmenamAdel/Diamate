import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diamate/core/services/hive/hive_service.dart';

class NotificationLocalService {
  static const String _boxName = 'notifications_box';

  Future<void> init() async {
    HiveService.registerAdapter(PushNotificationModelAdapter());
    try {
      await HiveService.openBox<PushNotificationModel>(_boxName);
    } catch (e) {
      // In case of schema mismatch (like adding isRead field), wipe the box
      await Hive.deleteBoxFromDisk(_boxName);
      await HiveService.openBox<PushNotificationModel>(_boxName);
    }
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

  Future<void> deleteNotification(dynamic key) async {
    if (_box.containsKey(key)) {
      await _box.delete(key);
    } else if (key is String) {
      // If key is a string and not a direct key, try searching by title or payload (productId)
      final keysToDelete = _box.keys.where((k) {
        final item = _box.get(k);
        return item?.title == key || item?.productId == key;
      }).toList();
      await _box.deleteAll(keysToDelete);
    }
  }

  Future<void> deleteMultipleNotifications(List<dynamic> keys) async {
    await _box.deleteAll(keys);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  int getUnreadCount() {
    return _box.values.where((notification) => !notification.isRead).length;
  }

  Future<void> markAsRead(dynamic key) async {
    final notification = _box.get(key);
    if (notification != null && !notification.isRead) {
      notification.isRead = true;
      await notification.save();
    }
  }

  Future<void> markAllAsRead() async {
    for (var notification in _box.values) {
      if (!notification.isRead) {
        notification.isRead = true;
        await notification.save();
      }
    }
  }
}
