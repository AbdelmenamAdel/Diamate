import 'package:flutter/material.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets(
    //   {
    //   required this.appSplash,
    //   required this.appIcon,
    //   required this.themeIcon,
    //   required this.doctor,
    //   required this.login,
    // }
  );

  // final String? appSplash;
  // final String? appIcon;
  // final String? doctor;
  // final String? themeIcon;
  // final String? login;

  @override
  ThemeExtension<MyAssets> copyWith(
    // {
    // String? appSplash,
    // String? appIcon,
    // String? doctor,
    // String? login,
    // String? themeIcon,
    // }
  ) {
    return MyAssets(
      // appSplash: appSplash,
      // appIcon: appIcon,
      // doctor: doctor,
      // login: login,
      // themeIcon: themeIcon,
    );
  }

  @override
  ThemeExtension<MyAssets> lerp(
    covariant ThemeExtension<MyAssets>? other,
    double t,
  ) {
    if (other is! MyAssets) {
      return this;
    }
    return MyAssets(
      // appSplash: appSplash,
      // appIcon: appIcon,
      // doctor: doctor,
      // login: login,
      // themeIcon: themeIcon,
    );
  }

  static const MyAssets dark = MyAssets(
    // appSplash: Assets.appSplashDark,
    // appIcon: Assets.appIconDark,
    // doctor: Assets.doctorDark,
    // login: Assets.loginDark,
    // themeIcon: Assets.lightTheme,
  );

  static const MyAssets light = MyAssets(
    // appSplash: Assets.appSplashWhite,
    // appIcon: Assets.appIconLight,
    // doctor: Assets.doctorLight,
    // login: Assets.loginLight,
    // themeIcon: Assets.darkTheme,
  );
}
