import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'onboarding_video_player.dart';
import 'onboarding_progress_dots.dart';
import 'onboarding_next_button.dart';

class WelcomeScreen extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VideoPlayerController videoController;
  final bool hasVideoError;

  const WelcomeScreen({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.videoController,
    this.hasVideoError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Hero Video or Fallback Image
          Expanded(
            flex: 5,
            child: hasVideoError
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: ColorsLight.primaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.diamateIcon,
                            height: 120.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'DiaMate',
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsLight.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : OnboardingVideoPlayer(controller: videoController),
          ),
          SizedBox(height: 32.h),
          // Title
          Text(
            "Welcome to DiaMate",
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
              "Your smart companion for daily diabetes care. Experience AI-powered monitoring and seamless medical reporting.",
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
          OnboardingNextButton(text: "Next", onPressed: onNext),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
