import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/notifications/data/models/push_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final Set<dynamic> _selectedKeys = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
  }

  bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  void _toggleSelection(dynamic key) {
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
        if (_selectedKeys.isEmpty) _isSelectionMode = false;
      } else {
        _selectedKeys.add(key);
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelected() async {
    final count = _selectedKeys.length;
    await sl<NotificationLocalService>().deleteMultipleNotifications(
      _selectedKeys.toList(),
    );

    if (mounted) {
      showAchievementView(
        context: context,
        title: 'Deleted Successfully',
        subTitle: 'Removed $count notifications from your history.',
        color: Colors.redAccent,
      );
    }

    setState(() {
      _selectedKeys.clear();
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.color.primaryColor ?? Colors.blue;
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomAppBar(
                      title: _isSelectionMode
                          ? '${_selectedKeys.length} Selected'
                          : 'Notifications',
                      notification: false,
                      onTap: () {
                        if (_isSelectionMode) {
                          setState(() {
                            _selectedKeys.clear();
                            _isSelectionMode = false;
                          });
                        } else {
                          context.pop();
                        }
                      },
                    ),
                  ),
                  if (_isSelectionMode)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: _deleteSelected,
                    ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<PushNotificationModel>(
                  'notifications_box',
                ).listenable(),
                builder: (context, Box<PushNotificationModel> box, _) {
                  if (box.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          const Text(
                            'No notifications yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
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
                      final isAr = _isArabic(notification.body);
                      final isSelected = _selectedKeys.contains(
                        notification.key,
                      );

                      return GestureDetector(
                        onLongPress: () => _toggleSelection(notification.key),
                        onTap: () {
                          if (_isSelectionMode) {
                            _toggleSelection(notification.key);
                          } else {
                            // Mark as read when clicked
                            sl<NotificationLocalService>().markAsRead(
                              notification.key,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor.withOpacity(0.1)
                                : (!notification.isRead
                                      ? primaryColor.withOpacity(0.04)
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(16.r),
                            border: isSelected
                                ? Border.all(color: primaryColor, width: 2)
                                : (!notification.isRead
                                      ? Border.all(
                                          color: primaryColor.withOpacity(0.3),
                                          width: 1.5,
                                        )
                                      : Border.all(
                                          color: Colors.black12,
                                          width: 0.5,
                                        )),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Stack(
                              children: [
                                if (!notification.isRead && !_isSelectionMode)
                                  Positioned(
                                    top: 12.h,
                                    right: isAr ? null : 12.w,
                                    left: isAr ? 12.w : null,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Text(
                                        'New',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ListTile(
                                  leading: _isSelectionMode
                                      ? Icon(
                                          isSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: primaryColor,
                                        )
                                      : null,
                                  contentPadding: EdgeInsets.all(16.w),
                                  title: Directionality(
                                    textDirection: isAr
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: Text(
                                      notification.title,
                                      style: TextStyle(
                                        fontWeight: !notification.isRead
                                            ? FontWeight.w800
                                            : FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: !notification.isRead
                                            ? primaryColor
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: isAr
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8.h),
                                      Directionality(
                                        textDirection: isAr
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        child: Text(
                                          notification.body,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                        mainAxisAlignment: isAr
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 14.sp,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            _formatDate(notification.createAt),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
