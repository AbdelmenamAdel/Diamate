import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:diamate/core/services/services_locator.dart';
import 'local_notfication_service.dart';

class FirebaseMessagingNavigate {
  // forground
  static Future<void> forGroundHandler(RemoteMessage? message) async {
    if (message != null) {
      await sl<LocalNotificationService>().showSimpleNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data['productId'].toString(),
      );
    }
  }

  // background
  static Future<void> backGroundHandler(RemoteMessage? message) async {
    if (message != null) {
      _navigate(message);
    }
  }

  // terminated
  static void terminatedHandler(RemoteMessage? message) {
    if (message != null) {
      _navigate(message);
    }
  }

  static void _navigate(RemoteMessage message) {
    if (int.parse(message.data['productId'].toString()) == -1) return;
    // sl<GlobalKey<NavigatorState>>().currentState!.context.pushName(
    //       AppRoutes.productDetails,
    //       arguments: int.parse(message.data['productId'].toString()),
    //     );
  }
}
