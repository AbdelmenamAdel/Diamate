import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'onboarding_progress_dots.dart';
import 'onboarding_next_button.dart';

class ReportsScreen extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  const ReportsScreen({
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
          // Reports Illustration Image
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                Assets.onboardingReportsIllustration,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // Title
          Text(
            "All Your Reports in One Place",
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
              "Upload lab tests, store medical history, and scan diabetic foot risks using AI.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 15.sp,
                color: ColorsLight.black.withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // Smart PDF Import card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: ColorsLight.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: ColorsLight.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smart PDF Import",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsLight.black,
                      ),
                    ),
                    Text(
                      "Auto-extract data from lab results",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 13.sp,
                        color: ColorsLight.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          OnboardingProgressDots(
            currentIndex: currentIndex,
            totalPages: totalPages,
          ),
          SizedBox(height: 20.h),
          OnboardingNextButton(text: "Next", onPressed: onNext),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
