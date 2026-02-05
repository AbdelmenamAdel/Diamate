import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'onboarding_feature_card.dart';
import 'onboarding_progress_dots.dart';
import 'onboarding_next_button.dart';

class TrackingScreen extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  const TrackingScreen({
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
          SizedBox(height: 24.h),
          // Feature Cards
          OnboardingFeatureCard(
            icon: Icons.water_drop,
            iconColor: ColorsLight.primaryColor,
            title: "Glucose Meter",
            subtitle: "Monitor sugar levels accurately",
          ),
          SizedBox(height: 12.h),
          OnboardingFeatureCard(
            icon: Icons.restaurant,
            iconColor: ColorsLight.primaryColor,
            title: "Food Plate",
            subtitle: "Log daily nutrition & carbs",
          ),
          SizedBox(height: 12.h),
          OnboardingFeatureCard(
            icon: Icons.show_chart,
            iconColor: ColorsLight.primaryColor,
            title: "Growth Chart",
            subtitle: "Visualize your health trends",
          ),
          const Spacer(),
          // Title
          Text(
            "Track Your Health\nEffortlessly",
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
            "Log glucose, track meals, and monitor your daily progress in seconds with our smart AI tools.",
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
