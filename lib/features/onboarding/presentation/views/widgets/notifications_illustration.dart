import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsIllustration extends StatelessWidget {
  const NotificationsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main card
        Container(
          width: 280.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bell icon container
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.notifications_active,
                  size: 48.sp,
                  color: ColorsLight.primaryColor,
                ),
              ),
              SizedBox(height: 24.h),
              // Document lines
              Container(
                height: 12.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECF0),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 12.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECF0),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 12.h,
                width: 180.w,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECF0),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
        // Green checkmark badge
        Positioned(
          top: 0,
          right: 20.w,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.check, color: Colors.white, size: 24.sp),
          ),
        ),
        // Insulin Reminder floating card
        Positioned(
          bottom: 20.h,
          right: -20.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    size: 18.sp,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Insulin Reminder",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsLight.black,
                      ),
                    ),
                    Text(
                      "12:30 PM • Lunch Time",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 12.sp,
                        color: ColorsLight.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
