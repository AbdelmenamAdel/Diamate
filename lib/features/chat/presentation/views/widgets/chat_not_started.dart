import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatNotStarted extends StatelessWidget {
  const ChatNotStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 24.h),
          Image.asset(height: 80.h, Assets.aiLogo),
          SizedBox(height: 12.h),
          Text(
            "Want better glucose control? Tell me your\ngoal, and I’ll show you the right tools",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(.5),
              fontFamily: K.sg,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
