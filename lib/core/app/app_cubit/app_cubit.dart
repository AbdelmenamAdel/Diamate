import 'dart:developer';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'app_state.dart';

enum ThemeEnum { light, dark, system }
enum LanguageEnum { ar, en, system }

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialState());
  // ignore: strict_top_level_inference
  static AppCubit get(context) => BlocProvider.of(context);

  ThemeEnum appTheme = ThemeEnum.system;

  //Theme Mode
  Future<void> changeAppThemeMode({ThemeEnum? selectedMode}) async {
    if (selectedMode != null) {
      appTheme = selectedMode;
    } else {
      // toggle manually between modes (for example, just dark/light)
      if (appTheme == ThemeEnum.light) {
        appTheme = ThemeEnum.dark;
      } else if (appTheme == ThemeEnum.dark) {
        appTheme = ThemeEnum.light;
      } else {
        appTheme = ThemeEnum.light;
      }
    }

    // Save selected mode to local storage
    await SecureStorage.setString(key: 'themeMode', value: appTheme.name);
    log("App theme changed to: ${appTheme.name}");
    emit(ThemeChangeModeState(appTheme: appTheme));
  }

  Future<void> getSavedThemeMode() async {
    final cachedMode = await SecureStorage.getString(key: 'themeMode');
    log("Cached theme mode: $cachedMode");
    if (cachedMode != null) {
      appTheme = ThemeEnum.values.firstWhere(
        (e) => e.name == cachedMode,
        orElse: () => ThemeEnum.system,
      );
    } else {
      appTheme = ThemeEnum.system;
    }
    emit(ThemeChangeModeState(appTheme: appTheme));
  }

  LanguageEnum appLanguage = LanguageEnum.system;

  // Language Mode
  Future<void> changeAppLanguageMode({required LanguageEnum selectedLanguage}) async {
    appLanguage = selectedLanguage;
    await SecureStorage.setString(key: 'appLanguage', value: appLanguage.name);
    log("App language changed to: ${appLanguage.name}");
    emit(LanguageChangeModeState(appLanguage: appLanguage));
  }

  Future<void> getSavedLanguageMode() async {
    final cachedLang = await SecureStorage.getString(key: 'appLanguage');
    log("Cached language mode: $cachedLang");
    if (cachedLang != null) {
      appLanguage = LanguageEnum.values.firstWhere(
        (e) => e.name == cachedLang,
        orElse: () => LanguageEnum.system,
      );
    } else {
      appLanguage = LanguageEnum.system;
    }
    emit(LanguageChangeModeState(appLanguage: appLanguage));
  }
}
