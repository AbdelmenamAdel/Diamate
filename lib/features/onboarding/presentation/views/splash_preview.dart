import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/styles/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPreview extends StatefulWidget {
  const SplashPreview({super.key});

  @override
  State<SplashPreview> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashPreview> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.pushReplacementNamed(AppRoutes.appGate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeLight(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: 150.h,
            child: Hero(tag: "splash", child: Image.asset(Assets.newLogo)),
          ),
        ),
      ),
    );
  }
}
