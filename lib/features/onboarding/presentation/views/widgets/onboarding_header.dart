import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingHeader extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onSkip;

  const OnboardingHeader({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(Assets.diamateIcon, height: 40, fit: BoxFit.contain),
              SizedBox(width: 8.w),
              Text(
                "DiaMate",
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsLight.black,
                ),
              ),
            ],
          ),
          // Only show Skip button on screens 0-4 (not on last screen)
          if (currentIndex < totalPages - 1)
            GestureDetector(
              onTap: onSkip,
              child: Text(
                "Skip",
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsLight.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
