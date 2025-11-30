import 'package:achievement_view/achievement_view.dart';
import 'package:diamate/core/styles/colors/colors_light.dart';
import 'package:flutter/material.dart';

void showAchievementView({
  required BuildContext context,
  String? title,
  String? subTitle,
  Color? color,
  void Function()? onTap,
  Alignment? alignment,
}) {
  AchievementView(
    duration: Duration(seconds: 2),
    title: title,
    onTap: onTap,
    alignment: alignment ?? Alignment.topCenter,
    subTitle: subTitle,
    color: color ?? ColorsLight.primaryColor,
  ).show(context);
}
