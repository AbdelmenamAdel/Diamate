import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';
import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:diamate/core/services/chat_companion_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:diamate/core/routes/app_routes.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<NotificationResponse>
  _notificationStreamController =
      StreamController<NotificationResponse>.broadcast();

  static Stream<NotificationResponse> get onNotificationClick =>
      _notificationStreamController.stream;

  static void Function(String title, String body)? onForegroundNotification;

  Future<void> init() async {
    tz.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // This is important for foreground notifications on some iOS versions
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      ),
    );

    // In version 20+, the initialize call uses settings: settings according to your project's analyzer
    try {
      await _flutterLocalNotificationsPlugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (details) {
          _onTap(details);
        },
      );
      debugPrint('✅ LocalNotificationService initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing LocalNotificationService: $e');
    }

    // Explicitly request permissions for iOS using the Darwin implementation (v20+)
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final darwinImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (darwinImplementation != null) {
        await darwinImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint('✅ iOS/Darwin permissions requested');
      }
    }
  }

  static void _onTap(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    _notificationStreamController.add(response);

    // Real-time Interaction: Auto-navigate to notifications if tapped
    if (response.payload != null) {
      final context = AppRoutes.navigatorKey.currentContext;
      if (context != null) {
        // If it's a water reminder or general notification, take them to the list
        if (response.payload == 'notifications' ||
            response.payload == 'water_reminder' ||
            response.payload == 'welcomo') {
          Navigator.pushNamed(context, AppRoutes.notifications);
        }
      }
    }
  }

  /// Schedule water reminders at specific hours/minutes
  Future<void> scheduleWaterReminders() async {
    final now = DateTime.now();
    final reminders = [
      // Dynamic Test Reminders (requested by user)
      {
        'id': 202,
        'hour': (now.add(const Duration(minutes: 2))).hour,
        'minute': (now.add(const Duration(minutes: 2))).minute,
        'title': 'تذكير تجريبي (2 د) ⏱️',
        'body': 'هذا الإشعار المجدول الأول وصل بنجاح!',
      },
      {
        'id': 204,
        'hour': (now.add(const Duration(minutes: 4))).hour,
        'minute': (now.add(const Duration(minutes: 4))).minute,
        'title': 'تذكير تجريبي (4 د) ⏱️',
        'body': 'تأكيد وصول الإشعار الثاني مع الصوت.',
      },
      {
        'id': 206,
        'hour': (now.add(const Duration(minutes: 6))).hour,
        'minute': (now.add(const Duration(minutes: 6))).minute,
        'title': 'تذكير تجريبي (6 د) ⏱️',
        'body': 'الإشعار الثالث يعمل بنجاح في الخلفية.',
      },
      {
        'id': 208,
        'hour': (now.add(const Duration(minutes: 8))).hour,
        'minute': (now.add(const Duration(minutes: 8))).minute,
        'title': 'تذكير تجريبي (8 د) ⏱️',
        'body': 'الإشعار الرابع للتأكد من استمرارية الجدولة.',
      },
      {
        'id': 210,
        'hour': (now.add(const Duration(minutes: 10))).hour,
        'minute': (now.add(const Duration(minutes: 10))).minute,
        'title': 'تذكير تجريبي (10 د) ⏱️',
        'body': 'الإشعار الخامس والأخير، الجدولة مثالية!',
      },
      // Original Water Reminders
      {
        'id': 100,
        'hour': 9,
        'title': 'وقت شرب الماء 💧',
        'body': 'ابدأ يومك بنشاط واشرب كوب ماس الآن.',
      },
      {
        'id': 101,
        'hour': 12,
        'title': 'تذكير شرب الماء ✨',
        'body': 'مرت ساعات قليلة، جسمك يحتاج للترطيب.',
      },
      {
        'id': 102,
        'hour': 15,
        'title': 'لا تنسى الماء! 🧊',
        'body': 'كوب ماء الآن سيجدد طاقتك لبقية اليوم.',
      },
      {
        'id': 103,
        'hour': 18,
        'title': 'حافظ على رطوبتك 🌊',
        'body': 'شرب الماء بانتظام يحسن من صحتك العامة.',
      },
      {
        'id': 106,
        'hour': 20,
        'minute': 55,
        'title': 'اشرب كوب ماء 🥤',
        'body': 'اشرب كوب ماء الآن.',
      },
      {
        'id': 107,
        'hour': 20,
        'minute': 48,
        'title': 'اشرب كوب ماء 🥤',
        'body': 'اشرب كوب ماء الآن.',
      },
      {
        'id': 108,
        'hour': 20,
        'minute': 50,
        'title': 'اشرب كوب ماء 🥤',
        'body': 'اشرب كوب ماء الآن.',
      },
      {
        'id': 109,
        'hour': 20,
        'minute': 52,
        'title': 'اشرب كوب ماء 🥤',
        'body': 'اشرب كوب ماء الآن.',
      },
      {
        'id': 104,
        'hour': 21,
        'title': 'كوب ماء قبل المساء 🌙',
        'body': 'أنهِ يومك بترطيب جيد لجسمك.',
      },
      {
        'id': 105,
        'hour': 23,
        'title': 'كوب ماء قبل النوم 🌙',
        'body': 'اشرب كوب ماء قبل النوم .',
      },
    ];

    for (var reminder in reminders) {
      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        reminder['hour'] as int,
        (reminder['minute'] ?? 0) as int,
      );

      // If the time has passed today (more than 1 minute ago), schedule for tomorrow
      // This allows notifications set for the CURRENT minute to still fire.
      if (scheduledDate.isBefore(now.subtract(const Duration(minutes: 1)))) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await scheduleNotification(
        id: reminder['id'] as int,
        title: reminder['title'] as String,
        body: reminder['body'] as String,
        scheduledDate: scheduledDate,
        payload: 'water_reminder',
      );
    }
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    // If foreground callback is set, it means app is open
    // We show the dialog but ALSO show the system notification
    if (onForegroundNotification != null) {
      onForegroundNotification!(title, body);
    }

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'diamate-id',
        'diamate-name',
        channelDescription: 'diamate-channel',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/launcher_icon',
        ticker: 'DiaMate Alert',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
      ),
    );

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
        productId: payload,
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
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'diamate-high-id',
          'diamate-high-name',
          channelDescription: 'Main channel for health alerts',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
          presentList: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Save to Hive with the future date (scheduledDate)
    // Prevent duplicates by checking if an exact same reminder exists
    final service = sl<NotificationLocalService>();
    final exists = Hive.box<PushNotificationModel>('notifications_box').values
        .any(
          (n) => n.title == title && n.createAt.isAtSameMomentAs(scheduledDate),
        );

    if (!exists) {
      await service.addNotification(
        PushNotificationModel(
          title: title,
          body: body,
          productId: payload,
          createAt: scheduledDate,
        ),
      );
    }

    debugPrint(
      '⏰ Notification (ID: $id) scheduled and added to Hive for $scheduledDate',
    );
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
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Cancel all notifications and reset badge
  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
