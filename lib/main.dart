import 'package:diamate/core/app/app_cubit/app_cubit.dart';
import 'package:diamate/core/app/internet_settings/connectivity_controller.dart';
import 'package:diamate/core/app/internet_settings/no_internet.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/language/app_localizations_setup.dart';
import 'core/styles/theme/app_theme.dart';
import 'package:diamate/core/services/push_notification/local_notfication_service.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';

import 'package:diamate/core/utils/time_ago.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConnectivityController.instance.init();
  await setupInjector();
  TimeAgo.setup();

  // Test Local Notifications: Clear previous and send exactly one for verification
  final notifService = sl<LocalNotificationService>();
  final localNotifService = sl<NotificationLocalService>();

  // Clear existing to see "it only" as requested
  // await localNotifService.clearAll();

  // Send one high-quality message from morning or night category
  await notifService.showSimpleNotification(
    title: "مرحباً بك في DiaMate 💙",
    body: "أنا صديقك ومرافقك الصحي، هكون معاك خطوة بخطوة عشان نطمن على صحتك.",
    payload: "welco",
  );
  // Do not block app startup with optional background work. Run after first frame.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  runApp(
    BlocProvider(
      create: (context) => sl<AppCubit>()..getSavedThemeMode(),
      child: const DiaMate(),
    ),
  );
}

class DiaMate extends StatelessWidget {
  const DiaMate({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;

              final overlayStyle = SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: isDark
                    ? Brightness.light
                    : Brightness.dark,
                statusBarBrightness: isDark
                    ? Brightness.dark
                    : Brightness.light,
              );

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: overlayStyle,
                child: MaterialApp(
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  locale: AppLocalizationsSetup.supportedLocales.last,
                  theme: themeLight(),
                  // ! this mode here to controle the theme from here only uncomment these lines
                  // darkTheme: themeDark(),
                  // themeMode: _getThemeMode(context.watch<AppCubit>().appTheme),
                  builder: (context, child) => Stack(
                    children: [
                      if (child != null) child,
                      ValueListenableBuilder(
                        valueListenable:
                            ConnectivityController.instance.isConnected,
                        builder: (context, value, child) {
                          if (value) {
                            return const SizedBox.shrink();
                          } else {
                            return const NoInternetWidget();
                          }
                        },
                      ),
                    ],
                  ),
                  initialRoute: AppRoutes.initial,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  debugShowCheckedModeBanner: false,
                ),
              );
            },
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(ThemeEnum mode) {
    switch (mode) {
      case ThemeEnum.light:
        return ThemeMode.light;
      case ThemeEnum.dark:
        return ThemeMode.dark;
      case ThemeEnum.system:
        return ThemeMode.system;
    }
  }
}
