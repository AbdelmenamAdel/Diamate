import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.notifications);
      },
      child: Container(
        height: 42.h,
        width: 42.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black12,
        ),
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: ValueListenableBuilder(
            valueListenable: Hive.box<PushNotificationModel>(
              'notifications_box',
            ).listenable(),
            builder: (context, box, child) {
              final unreadCount = sl<NotificationLocalService>()
                  .getUnreadCount();
              return Badge(
                label: unreadCount > 0 ? Text(unreadCount.toString()) : null,
                isLabelVisible: unreadCount > 0,
                backgroundColor: context.color.primaryColor ?? Colors.blue,
                child: Center(child: Icon(Icons.notifications_active_outlined)),
              );
            },
          ),
        ),
      ),
    );
  }
}
