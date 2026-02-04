import 'package:diamate/core/services/push_notification/firebase_messaging_navigate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseCloudMessaging {
  static const String subscriptionKey = 'diamate_topic';

  final _firebaseMessaging = FirebaseMessaging.instance;
  ValueNotifier<bool> isSubscribe = ValueNotifier(true);
  bool isPermissionNotification = false;

  Future<void> init() async {
    // Permission
    await _permissionsNotification();

    // Foreground
    FirebaseMessaging.onMessage.listen(
      FirebaseMessagingNavigate.forGroundHandler,
    );

    // Terminated
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      FirebaseMessagingNavigate.terminatedHandler(initialMessage);
    }

    // Background
    FirebaseMessaging.onBackgroundMessage(
      FirebaseMessagingNavigate.backGroundHandler,
    );

    // Background (from notification bar)
    FirebaseMessaging.onMessageOpenedApp.listen(
      FirebaseMessagingNavigate.backGroundHandler,
    );
  }

  /// Permissions for notifications
  Future<void> _permissionsNotification() async {
    final settings = await _firebaseMessaging.requestPermission(badge: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      isPermissionNotification = true;
      await _subscribeNotification();
      debugPrint('🔔 User accepted notification permission');
    } else {
      isPermissionNotification = false;
      isSubscribe.value = false;
      debugPrint('🔕 User denied notification permission');
    }
  }

  /// Subscribe to topic
  Future<void> _subscribeNotification() async {
    isSubscribe.value = true;
    await _firebaseMessaging.subscribeToTopic(subscriptionKey);
    debugPrint('==== 🔔 Notification Subscribed 🔔 =====');
  }

  /// Unsubscribe from topic
  Future<void> _unSubscribeNotification() async {
    isSubscribe.value = false;
    await _firebaseMessaging.unsubscribeFromTopic(subscriptionKey);
    debugPrint('==== 🔕 Notification Unsubscribed 🔕 =====');
  }

  /// Controller for user subscription toggle
  Future<void> toggleSubscription() async {
    if (!isPermissionNotification) {
      await _permissionsNotification();
    } else {
      if (!isSubscribe.value) {
        await _subscribeNotification();
      } else {
        await _unSubscribeNotification();
      }
    }
  }

  Future<void> sendTopicNotification({
    required String title,
    required String body,
    required int productId,
  }) async {
    // This typically requires a server-side implementation or a legacy Firebase API key
    // For now, we keep the signature as requested.
    debugPrint('📤 Sending Topic Notification: $title - $body');
  }
}
