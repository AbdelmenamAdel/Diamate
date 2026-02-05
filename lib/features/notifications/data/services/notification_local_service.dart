import 'dart:async';
import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diamate/core/services/hive/hive_service.dart';

class NotificationLocalService {
  static const String _boxName = 'notifications_box';

  // Stream to trigger UI updates (both on Hive changes and Time passing)
  final StreamController<void> _updateController = StreamController.broadcast();
  Stream<void> get notificationStream => _updateController.stream;

  Timer? _nextNotificationTimer;

  Future<void> init() async {
    HiveService.registerAdapter(PushNotificationModelAdapter());
    try {
      await HiveService.openBox<PushNotificationModel>(_boxName);
    } catch (e) {
      await Hive.deleteBoxFromDisk(_boxName);
      await HiveService.openBox<PushNotificationModel>(_boxName);
    }

    // 1. Listen to Database Changes & Schedule Next Update
    _box.watch().listen((event) {
      _updateController.add(null);
      _scheduleNextUpdate();
    });

    // 2. Initial Schedule
    _scheduleNextUpdate();
  }

  // Trigger manual refresh (useful for onResume)
  void refresh() {
    _updateController.add(null);
    _scheduleNextUpdate();
  }

  /// Finds the next upcoming notification and sets a timer to refresh UI exactly when it arrives
  void _scheduleNextUpdate() {
    _nextNotificationTimer?.cancel();

    final now = DateTime.now();
    // Find earliest notification that is still in the future
    final futureNotifications = _box.values
        .where((n) => n.createAt.isAfter(now))
        .map((n) => n.createAt)
        .toList();

    if (futureNotifications.isEmpty) return;

    // Sort to get the nearest one
    futureNotifications.sort();
    final nextTime = futureNotifications.first;

    final duration = nextTime.difference(now);

    // Add a small buffer (e.g., 1 second) to ensure "now" has definitely passed the time when timer fires
    _nextNotificationTimer = Timer(duration + const Duration(seconds: 1), () {
      _updateController.add(null); // Refresh UI
      _scheduleNextUpdate(); // Schedule for the one after that
    });
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
    final now = DateTime.now();
    return _box.values.where((notification) {
      final isTimePassed =
          notification.createAt.isBefore(now) ||
          notification.createAt.isAtSameMomentAs(now);
      return !notification.isRead && isTimePassed;
    }).length;
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
