part of 'app_cubit.dart';

// @immutable
// abstract class AppState {}

// class InitialState extends AppState {}

// class InitialUserEntityState extends AppState {}

// class ThemeChangeModeState extends AppState {
//   final bool isDark;
//   ThemeChangeModeState({required this.isDark});
// }

@immutable
abstract class AppState {}

class InitialState extends AppState {}

class ThemeChangeModeState extends AppState {
  final ThemeEnum appTheme;
  ThemeChangeModeState({required this.appTheme});
}

// class ChangeLangLoading extends AppState {}

// class ChangeLangSuccess extends AppState {}
