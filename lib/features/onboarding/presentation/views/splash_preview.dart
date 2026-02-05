import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
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
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      context.pushReplacementNamed(AppRoutes.splash);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
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
