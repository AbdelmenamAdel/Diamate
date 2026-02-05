import 'package:diamate/core/app/app_cubit/app_cubit.dart';
import 'package:diamate/core/app/internet_settings/connectivity_controller.dart';
import 'package:diamate/core/app/internet_settings/no_internet.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/notifications/data/services/notification_local_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/language/app_localizations_setup.dart';
import 'core/styles/theme/app_theme.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/services/push_notification/local_notfication_service.dart';
import 'package:diamate/core/utils/time_ago.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConnectivityController.instance.init();
  await setupInjector();
  TimeAgo.setup();

  final notifService = sl<LocalNotificationService>();

  // Clear all notifications (system tray & local DB) - Cleaning slate for testing flow
  await notifService.cancelAll();
  await sl<NotificationLocalService>().clearAll();

  // First Time Greeting Logic
  final hasWelcome = await SecureStorage.getBoolean(key: 'has_welcome_v1');
  if (hasWelcome != true) {
    Future.delayed(const Duration(seconds: 4), () async {
      await notifService.showSimpleNotification(
        title: "مرحباً بك في DiaMate 💙",
        body: "نتمنى لك رحلة صحية ممتعة! إشعاراتك جاهزة للعمل.",
        payload: "welcome_msg",
      );
    });
    await SecureStorage.setBoolean(key: 'has_welcome_v1', value: true);
  }

  // Schedule water reminders (includes the 5 test notifications)
  await notifService.scheduleWaterReminders();
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

class DiaMate extends StatefulWidget {
  const DiaMate({super.key});

  @override
  State<DiaMate> createState() => _DiaMateState();
}

class _DiaMateState extends State<DiaMate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh notifications when app comes back to foreground
      sl<NotificationLocalService>().refresh();
    }
  }

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
                  darkTheme: themeDark(),
                  themeMode: _getThemeMode(context.watch<AppCubit>().appTheme),
                  navigatorKey: AppRoutes.navigatorKey,
                  initialRoute: AppRoutes.initial,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    // Set up foreground notification dialog handler
                    LocalNotificationService
                        .onForegroundNotification = (title, body) {
                      final navContext = AppRoutes.navigatorKey.currentContext;
                      if (navContext != null) {
                        showCupertinoDialog(
                          context: navContext,
                          barrierDismissible: false,
                          builder: (context) => CupertinoAlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.drop_fill,
                                  color: CupertinoColors.activeBlue,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontFamily:
                                        'Cairo', // Matching your app's font
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            content: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                body,
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                            ),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Done',
                                  style: TextStyle(
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    };

                    return Stack(
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
                    );
                  },
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
