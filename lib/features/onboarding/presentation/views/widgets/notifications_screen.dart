import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'notifications_illustration.dart';
import 'onboarding_progress_dots.dart';
import 'onboarding_next_button.dart';

class NotificationsScreen extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onEnableNotifications;

  const NotificationsScreen({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onEnableNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Notifications Illustration - Custom Design
          Expanded(flex: 5, child: const NotificationsIllustration()),
          SizedBox(height: 32.h),
          // Title
          Text(
            "Stay on Track",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: ColorsLight.black,
            ),
          ),
          SizedBox(height: 16.h),
          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Get smart reminders for glucose checks, medications, and meals tailored to your schedule.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 15.sp,
                color: ColorsLight.black.withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ),
          const Spacer(),
          OnboardingProgressDots(
            currentIndex: currentIndex,
            totalPages: totalPages,
          ),
          SizedBox(height: 24.h),
          OnboardingNextButton(
            text: "Enable Notifications",
            onPressed: onEnableNotifications,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
