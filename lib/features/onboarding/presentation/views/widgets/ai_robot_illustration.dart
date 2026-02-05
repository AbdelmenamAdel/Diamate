import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiRobotIllustration extends StatelessWidget {
  const AiRobotIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Background gradient circle
        Container(
          width: 280.w,
          height: 280.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                ColorsLight.primaryColor.withOpacity(0.1),
                ColorsLight.primaryColor.withOpacity(0.02),
              ],
            ),
          ),
        ),
        // Robot Image
        Image.asset(Assets.aiRobot, height: 300.h, fit: BoxFit.contain),
        // Floating message bubble - left
        Positioned(
          left: -35,
          top: 90.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16.sp,
                  color: ColorsLight.primaryColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  "Ask me anything!",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsLight.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating badge - right
        Positioned(
          right: 0,
          top: 130.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorsLight.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorsLight.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 16.sp, color: Colors.white),
                SizedBox(width: 6.w),
                Text(
                  "24/7 Available",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
