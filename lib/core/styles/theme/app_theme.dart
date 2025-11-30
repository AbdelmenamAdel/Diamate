import 'package:diamate/core/styles/colors/colors_dark_.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/core/styles/theme/assets_extensions.dart';
import 'package:diamate/core/styles/theme/color_extension.dart';
import 'package:flutter/material.dart';

ThemeData themeDark() {
  return ThemeData(
    primaryColorDark: Colors.blue,
    primaryColorLight: Colors.blueAccent,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: ColorsLight.black,
    extensions: const <ThemeExtension<dynamic>>[MyColors.dark, MyAssets.dark],
    useMaterial3: true,
    primaryColor: ColorsDark.primaryColor,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent),
      ),
    ),
  );
}

ThemeData themeLight() {
  return ThemeData(
    primaryColorDark: Colors.blue,
    primaryColorLight: Colors.blueAccent,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),

        borderSide: BorderSide(color: Colors.transparent),
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[MyColors.light, MyAssets.light],
    useMaterial3: true,
    primaryColor: ColorsLight.primaryColor,
  );
}
