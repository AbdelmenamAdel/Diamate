import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:diamate/core/database/secure_storage.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    _navigateToNext();
    super.initState();
  }

  Future<void> _navigateToNext() async {
    final isLogged = await SecureStorage.getBoolean(key: K.isLogged) ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (isLogged) {
      context.pushReplacementNamed(AppRoutes.chatbot);
    } else {
      context.pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120.h),
            SizedBox(
              height: 100.h,
              child: Hero(tag: "splash", child: Image.asset(Assets.newLogo)),
            ),
            SizedBox(height: 24.h),
            Text(
              "support for your daily",
              style: TextStyle(
                height: 1.8,
                fontWeight: FontWeight.w500,
                fontFamily: K.sg,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "health journey by",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: K.sg,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                  ),
                  child: Text(
                    "AI-Powered",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: K.sg,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Image.asset(Assets.splashBg),
          ],
        ),
      ),
    );
  }
}
