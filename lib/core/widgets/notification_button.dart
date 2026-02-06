import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          color: context.color.blackAndWhite!.withOpacity(0.1),
        ),
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: context.color.cardColor,
          ),
          child: StreamBuilder<void>(
            stream: sl<NotificationLocalService>().notificationStream,
            builder: (context, snapshot) {
              final unreadCount = sl<NotificationLocalService>()
                  .getUnreadCount();
              return Badge(
                label: unreadCount > 0 ? Text(unreadCount.toString()) : null,
                isLabelVisible: unreadCount > 0,
                backgroundColor: context.color.primaryColor ?? Colors.blue,
                child: Center(
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: context.color.textColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
