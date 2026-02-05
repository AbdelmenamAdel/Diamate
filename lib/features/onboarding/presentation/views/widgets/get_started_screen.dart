import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'onboarding_progress_dots.dart';
import 'onboarding_next_button.dart';

class GetStartedScreen extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onGetStarted;

  const GetStartedScreen({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Hero Image
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                Assets.getStartedHero,
                fit: BoxFit.fill,
                // width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Title
          Text(
            "Start Your Journey\nToday",
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
            "Take control of your health with DiaMate's smart monitoring and AI-powered insights.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 15.sp,
              color: ColorsLight.black.withOpacity(0.6),
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          OnboardingProgressDots(
            currentIndex: currentIndex,
            totalPages: totalPages,
          ),
          SizedBox(height: 24.h),
          OnboardingNextButton(text: "Get Started", onPressed: onGetStarted),
          SizedBox(height: 12.h),
          // Terms text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 13.sp,
                  color: ColorsLight.black.withOpacity(0.5),
                ),
                children: [
                  const TextSpan(text: "By continuing, you agree to our "),
                  TextSpan(
                    text: "Terms of Service",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: ColorsLight.black.withOpacity(0.7),
                    ),
                  ),
                  const TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: ColorsLight.black.withOpacity(0.7),
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
