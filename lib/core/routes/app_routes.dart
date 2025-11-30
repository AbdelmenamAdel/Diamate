import 'package:diamate/features/auth/presentation/views/login_view.dart';
import 'package:diamate/features/auth/presentation/views/signup_view.dart';
import 'package:diamate/features/chat/presentation/views/chatbot_view.dart';
import 'package:diamate/features/main/presentation/views/main_view.dart';
import 'package:diamate/features/onboarding/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'base_routes.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = 'login';
  static const String main = 'main';
  static const String signUp = 'signUp';
  static const String chatbot = 'chatbot';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    // var arg = settings.arguments;
    switch (settings.name) {
      case initial:
        return BaseRoute(page: const SplashView());
      case main:
        return BaseRoute(page: const MainView());
      case login:
        return BaseRoute(page: const LoginView());
      case signUp:
        return BaseRoute(page: const SignupView());
      case chatbot:
        return BaseRoute(page: const ChatbotView());
      default:
        return BaseRoute(
          page: const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
