import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SocialBtn extends StatelessWidget {
  const SocialBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: const Color(0x1F1F1E1F), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.symmetric(vertical: 20.h),
      ),
      onPressed: () {},

      child: Row(
        spacing: 8.w,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Login with Google",
            style: TextStyle(
              color: Colors.black,
              fontFamily: K.sg,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
          SvgPicture.asset(Assets.google, height: 16.h, width: 16.w),
        ],
      ),
    );
  }
}
