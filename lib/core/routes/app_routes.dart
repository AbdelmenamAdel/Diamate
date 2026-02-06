import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/auth/presentation/views/login_view.dart';
import 'package:diamate/features/auth/presentation/views/signup_view.dart';
import 'package:diamate/features/chat/presentation/views/chatbot_view.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:diamate/features/dfu_test/presentation/views/dfu_tests_list_view.dart';
import 'package:diamate/features/glucose/presentation/managers/glucose_cubit.dart';
import 'package:diamate/features/glucose/presentation/views/glucose_readings_list_view.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';
import 'package:diamate/features/lab_tests/presentation/views/lab_tests_list_view.dart';
import 'package:diamate/features/main/presentation/views/main_view.dart';
import 'package:diamate/features/notifications/presentation/views/notification_view.dart';
import 'package:diamate/features/onboarding/presentation/views/splash_preview.dart';
import 'package:diamate/features/onboarding/presentation/views/splash_view.dart';
import 'package:diamate/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:diamate/features/profile/presentation/views/about_developers_view.dart';
import 'package:diamate/core/utils/mini/recomte_configure.dart';
import 'package:diamate/core/utils/mini/lol_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_routes.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String initial = '/';
  static const String splashPreview = 'splashPreview';
  static const String appGate = 'appGate';
  static const String lol = 'lol';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String main = 'main';
  static const String signUp = 'signUp';
  static const String chatbot = 'chatbot';
  static const String notifications = 'notifications';
  static const String aboutDevelopers = 'aboutDevelopers';
  static const String glucoseReadings = 'glucoseReadings';
  static const String labTests = 'labTests';
  static const String dfuTests = 'dfuTests';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return BaseRoute(page: const SplashView());
      case splashPreview:
        return BaseRoute(page: const SplashPreview());
      case appGate:
        return BaseRoute(page: const AppGate());
      case lol:
        return BaseRoute(page: const LolView());
      case main:
        return BaseRoute(page: const MainView());
      case onboarding:
        return BaseRoute(page: const OnboardingView());
      case login:
        return BaseRoute(page: const LoginView());
      case signUp:
        return BaseRoute(page: const SignupView());
      case chatbot:
        return BaseRoute(page: const ChatbotView());
      case notifications:
        return BaseRoute(page: const NotificationsView());
      case aboutDevelopers:
        return BaseRoute(page: const AboutDevelopersView());
      case glucoseReadings:
        return BaseRoute(
          page: BlocProvider<GlucoseCubit>(
            create: (context) => sl<GlucoseCubit>(),
            child: const GlucoseReadingsListView(),
          ),
        );
      case labTests:
        return BaseRoute(
          page: BlocProvider<LabTestCubit>(
            create: (context) => sl<LabTestCubit>(),
            child: const LabTestsListView(),
          ),
        );
      case dfuTests:
        return BaseRoute(
          page: BlocProvider<DfuTestCubit>(
            create: (context) => sl<DfuTestCubit>(),
            child: const DfuTestsListView(),
          ),
        );
      default:
        return BaseRoute(
          page: const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
