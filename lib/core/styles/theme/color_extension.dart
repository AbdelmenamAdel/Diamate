// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:diamate/core/styles/colors/colors_dark_.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:flutter/material.dart';

class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.containerColor,
    required this.textColor,
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
  final Color? containerColor;
  final Color? textColor;
  final Color? login;
  final Color? hint;
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
    Color? containerColor,
    Color? textColor,
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
      containerColor: containerColor ?? this.containerColor,
      textColor: textColor ?? this.textColor,
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
      customButton: Color.lerp(customButton, other.customButton, t),
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      containerColor: Color.lerp(containerColor, other.containerColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
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
    containerColor: ColorsLight.white,
    textColor: ColorsLight.primaryColor,
    login: ColorsLight.primaryColor,
    customButton: ColorsLight.primaryColor,
    blackAndWhite: ColorsLight.black,

    hint: ColorsLight.primaryColor,
    createAcc: ColorsLight.black,
    bg: Color(0xFFE2E7EA),
    decribtion: ColorsLight.black,
    dntHaveAcc: ColorsLight.secondaryColor,
  );

  static const MyColors dark = MyColors(
    primaryColor: ColorsDark.primaryColor,
    secondaryColor: ColorsDark.secondaryColor,
    containerColor: ColorsDark.black2,
    textColor: ColorsLight.white,
    customButton: Color(0xff1E1F25),
    blackAndWhite: ColorsLight.white,
    login: ColorsDark.secondaryColor,
    hint: ColorsLight.white,
    bg: ColorsLight.black,
    decribtion: ColorsLight.white,
    dntHaveAcc: ColorsLight.white,
    createAcc: ColorsDark.secondaryColor,
  );
}
