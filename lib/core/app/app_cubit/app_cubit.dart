import 'dart:developer';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'app_state.dart';

enum ThemeEnum { light, dark, system }

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

  String langCode = 'en';

  // //! get lang and set it in sharedPrefrances
  // void updateLang(String code) {
  //   emit(ChangeLangLoading());
  //   langCode = code;
  //   sl<LocalStorage>().changLanguage(code);
  //   emit(ChangeLangSuccess());
  // }

  // //! update langauge and use it while starting app
  // void getLang() {
  //   emit(ChangeLangLoading());
  //   final cachedLang = sl<LocalStorage>().getCachedLanguage();
  //   langCode = cachedLang;
  //   emit(ChangeLangSuccess());
  // }
}
