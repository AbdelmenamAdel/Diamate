import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: CustomAppBar(
                title: 'Notifications',
                notification: false,
                onTap: () {
                  context.pop();
                },
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<PushNotificationModel>(
                  'notifications_box',
                ).listenable(),
                builder: (context, Box<PushNotificationModel> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notifications yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final notifications = box.values.toList().reversed.toList();

                  return ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12.w),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text(
                                notification.body,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  _formatDate(notification.createAt),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
