import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HaveNoAccQ extends StatelessWidget {
  const HaveNoAccQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 28.h,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You don’t have an account ? ",
            style: TextStyle(
              fontFamily: K.sg,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
          InkWell(
            onTap: () {
              context.pushNamed(AppRoutes.signUp);
            },
            child: Text(
              "Create Account",
              style: TextStyle(
                fontFamily: K.sg,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                height: 2,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
