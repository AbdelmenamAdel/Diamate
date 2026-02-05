// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diamate/core/styles/colors/colors_dark.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:flutter/material.dart';

class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.cardColor,
    required this.navBarColor,
    required this.scaffoldBackgroundColor,
    required this.cursorColor,
    required this.hintColor,
    required this.containerColor,
    // Legacy mapping or specific uses
    required this.backgroundColor,
    required this.login,
    required this.hint,
    required this.bg,
    required this.decribtion,
    required this.createAcc,
    required this.dntHaveAcc,
    required this.blackAndWhite,
    required this.customButton,
  });

  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? textColor;
  final Color? cardColor;
  final Color? navBarColor;
  final Color? scaffoldBackgroundColor;
  final Color? cursorColor;
  final Color? hintColor;
  final Color? containerColor;

  // Legacy / Specific
  final Color? backgroundColor; // Mapping to scaffoldBackgroundColor usually
  final Color? login;
  final Color? hint; // Legacy hint, can map to hintColor
  final Color? bg;
  final Color? decribtion;
  final Color? createAcc;
  final Color? dntHaveAcc;
  final Color? blackAndWhite;
  final Color? customButton;

  @override
  ThemeExtension<MyColors> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? textColor,
    Color? cardColor,
    Color? navBarColor,
    Color? scaffoldBackgroundColor,
    Color? cursorColor,
    Color? hintColor,
    Color? containerColor,
    Color? backgroundColor,
    Color? login,
    Color? hint,
    Color? bg,
    Color? createAcc,
    Color? dntHaveAcc,
    Color? customButton,
    Color? decribtion,
    Color? blackAndWhite,
  }) {
    return MyColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      textColor: textColor ?? this.textColor,
      cardColor: cardColor ?? this.cardColor,
      navBarColor: navBarColor ?? this.navBarColor,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      cursorColor: cursorColor ?? this.cursorColor,
      hintColor: hintColor ?? this.hintColor,
      containerColor: containerColor ?? this.containerColor,

      backgroundColor: backgroundColor ?? this.backgroundColor,
      customButton: customButton ?? this.customButton,
      login: login ?? this.login,
      bg: bg ?? this.bg,
      blackAndWhite: blackAndWhite ?? this.blackAndWhite,
      decribtion: decribtion ?? this.decribtion,
      hint: hint ?? this.hint,
      dntHaveAcc: dntHaveAcc ?? this.dntHaveAcc,
      createAcc: createAcc ?? this.createAcc,
    );
  }

  @override
  ThemeExtension<MyColors> lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      cardColor: Color.lerp(cardColor, other.cardColor, t),
      navBarColor: Color.lerp(navBarColor, other.navBarColor, t),
      scaffoldBackgroundColor: Color.lerp(
        scaffoldBackgroundColor,
        other.scaffoldBackgroundColor,
        t,
      ),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      hintColor: Color.lerp(hintColor, other.hintColor, t),
      containerColor: Color.lerp(containerColor, other.containerColor, t),

      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      customButton: Color.lerp(customButton, other.customButton, t),
      login: Color.lerp(login, other.login, t),
      hint: Color.lerp(hint, other.hint, t),
      bg: Color.lerp(bg, other.bg, t),
      blackAndWhite: Color.lerp(blackAndWhite, other.blackAndWhite, t),
      decribtion: Color.lerp(decribtion, other.decribtion, t),
      dntHaveAcc: Color.lerp(dntHaveAcc, other.dntHaveAcc, t),
      createAcc: Color.lerp(createAcc, other.createAcc, t),
    );
  }

  static const MyColors light = MyColors(
    primaryColor: ColorsLight.primaryColor,
    secondaryColor: ColorsLight.secondaryColor,
    textColor: ColorsLight.text,
    cardColor: ColorsLight.cardColor,
    navBarColor: ColorsLight.navBarColor,
    scaffoldBackgroundColor: ColorsLight.scaffoldBackgroundColor,
    cursorColor: ColorsLight.cursorColor,
    hintColor: ColorsLight.hintColor,
    containerColor: ColorsLight.containerColor,

    backgroundColor: ColorsLight.scaffoldBackgroundColor,

    // Legacy Mappings
    login: ColorsLight.primaryColor,
    customButton: ColorsLight.primaryColor,
    blackAndWhite: ColorsLight.black,
    hint: ColorsLight.hintColor,
    createAcc: ColorsLight.black,
    bg: Color(0xFFE2E7EA),
    decribtion: ColorsLight.black,
    dntHaveAcc: ColorsLight.secondaryColor,
  );

  static const MyColors dark = MyColors(
    primaryColor: ColorsDark.primaryColor,
    secondaryColor: ColorsDark.secondaryColor,
    textColor: ColorsDark.text,
    cardColor: ColorsDark.cardColor,
    navBarColor: ColorsDark.navBarColor,
    scaffoldBackgroundColor: ColorsDark.scaffoldBackgroundColor,
    cursorColor: ColorsDark.cursorColor,
    hintColor: ColorsDark.hintColor,
    containerColor: ColorsDark.containerColor,

    backgroundColor: ColorsDark.scaffoldBackgroundColor,

    // Legacy Mappings
    login: ColorsDark.primaryColor,
    customButton: ColorsDark.primaryColor,
    blackAndWhite: ColorsDark.text,
    hint: ColorsDark.hintColor,
    bg: Color(0xFF1E1F25),
    decribtion: ColorsDark.text,
    dntHaveAcc: ColorsDark.text,
    createAcc: ColorsDark.primaryColor,
  );
}
