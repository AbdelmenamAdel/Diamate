import 'package:diamate/core/styles/theme/assets_extensions.dart';
import 'package:diamate/core/styles/theme/color_extension.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  //color
  MyColors get color => Theme.of(this).extension<MyColors>()!;

  // images
  MyAssets get assets => Theme.of(this).extension<MyAssets>()!;

  // // style
  // TextStyle get textStyle => Theme.of(this).textTheme.displaySmall!;

  //Language
  // String translate(String langkey) {
  //   return AppLocalizations.of(this)!.translate(langkey).toString();
  // }

  //Navigation

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  String extractVimeoId(String url) {
    final regExp = RegExp(r'vimeo\.com/(?:.*?/)?(\d+)');
    final match = regExp.firstMatch(url);
    return match?.group(1) ?? '';
  }

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  void pop() => Navigator.of(this).pop();
}
