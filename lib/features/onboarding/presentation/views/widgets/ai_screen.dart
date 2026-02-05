import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ai_robot_illustration.dart';
import 'onboarding_progress_dots.dart';
import 'onboarding_next_button.dart';

class AiScreen extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  const AiScreen({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Robot Image with floating elements
          Expanded(flex: 5, child: const AiRobotIllustration()),
          SizedBox(height: 24.h),
          // Title
          Text(
            "24/7 AI Medical\nSupport",
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
          Text(
            "Ask questions anytime and get instant, personalized guidance from our AI assistant.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 15.sp,
              color: ColorsLight.black.withOpacity(0.6),
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),
          OnboardingProgressDots(
            currentIndex: currentIndex,
            totalPages: totalPages,
          ),
          SizedBox(height: 24.h),
          OnboardingNextButton(text: "Next", onPressed: onNext),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
