import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';
import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:diamate/core/services/chat_companion_service.dart';
import 'package:flutter/foundation.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      onDidReceiveNotificationResponse: _onTap,
      settings: settings,
    );
  }

  void _onTap(NotificationResponse notificationResponse) {
    // Navigation logic will be implemented here when needed
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'diamate-id',
        'diamate-name',
        channelDescription: 'diamate-channel',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Show the notification
    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );

    // Save to local Hive database
    await sl<NotificationLocalService>().addNotification(
      PushNotificationModel(
        title: title,
        body: body,
        productId: int.tryParse(payload) ?? -1,
        createAt: DateTime.now(),
      ),
    );
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      payload: payload,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'diamate-scheduled-id',
          'diamate-scheduled-name',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('⏰ Notification scheduled for $scheduledDate');
  }

  /// Send random test notifications from ChatCompanionService
  Future<void> sendRandomTestNotifications() async {
    final companion = sl<ChatCompanionService>();
    final hour = DateTime.now().hour;
    String category = "General";
    List<String> messages;

    if (hour >= 5 && hour < 12) {
      category = "Morning Support";
      messages = companion.morningMessages;
    } else if (hour >= 12 && hour < 18) {
      category = "Daily Motivation";
      messages = companion.afterMealMessages;
    } else {
      category = "Night Support";
      messages = companion.nightAndStreakMessages;
    }

    // Shuffle and pick 3-5 messages
    final random = (DateTime.now().millisecond % 3) + 3; // 3 to 5
    final selectedMessages = (List<String>.from(
      messages,
    )..shuffle()).take(random).toList();

    for (var i = 0; i < selectedMessages.length; i++) {
      await showSimpleNotification(
        title: category,
        body: selectedMessages[i],
        payload: i.toString(),
      );
      // Small delay between notifications to ensure order/visibility
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
