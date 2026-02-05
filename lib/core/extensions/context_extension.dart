import 'package:diamate/core/styles/theme/assets_extensions.dart';
import 'package:diamate/core/styles/theme/color_extension.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  // Theme & Colors
  MyColors get color => Theme.of(this).extension<MyColors>()!;
  MyAssets get assets => Theme.of(this).extension<MyAssets>()!;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Media Query
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // Navigation Shortcuts
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
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> push(Widget page) {
    return Navigator.of(
      this,
    ).push(MaterialPageRoute(builder: (context) => page));
  }

  Future<dynamic> pushReplacement(Widget page) {
    return Navigator.of(
      this,
    ).pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  void pop([dynamic result]) {
    return Navigator.of(this).pop(result);
  }

  bool get canPop => Navigator.of(this).canPop();
}
