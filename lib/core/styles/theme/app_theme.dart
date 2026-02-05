import 'package:diamate/core/styles/colors/colors_dark.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:diamate/core/styles/theme/assets_extensions.dart';
import 'package:diamate/core/styles/theme/color_extension.dart';
import 'package:flutter/material.dart';

ThemeData themeDark() {
  return ThemeData(
    brightness: Brightness.dark, // Essential for default text colors
    primaryColorDark: Colors.blue,
    primaryColorLight: Colors.blueAccent,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor:
        ColorsDark.scaffoldBackgroundColor, // Consistent dark background
    extensions: const <ThemeExtension<dynamic>>[MyColors.dark, MyAssets.dark],
    useMaterial3: true,
    primaryColor: ColorsDark.primaryColor,

    // Cursor Color
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorsLight.cursorColor,
      selectionColor: ColorsDark.primaryColor.withOpacity(0.3),
      selectionHandleColor: ColorsDark.primaryColor,
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsDark.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: ColorsDark.text),
      titleTextStyle: TextStyle(
        color: ColorsDark.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsDark.navBarColor,
      selectedItemColor: ColorsDark.primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}

ThemeData themeLight() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColorDark: Colors.blue,
    primaryColorLight: Colors.blueAccent,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: ColorsLight.scaffoldBackgroundColor,

    // Cursor Color
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorsLight.cursorColor,
      selectionColor: ColorsLight.primaryColor.withOpacity(0.3),
      selectionHandleColor: ColorsLight.primaryColor,
    ),

    extensions: const <ThemeExtension<dynamic>>[MyColors.light, MyAssets.light],
    useMaterial3: true,
    primaryColor: ColorsLight.primaryColor,
  );
}
