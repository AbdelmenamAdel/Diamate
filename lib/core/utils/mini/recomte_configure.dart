import 'dart:developer';
import 'package:diamate/constant.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/services/remote_config_service.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/core/utils/mini/lol_view.dart';
import 'package:diamate/features/auth/presentation/views/login_view.dart';
import 'package:diamate/features/chat/presentation/views/chatbot_view.dart';
import 'package:flutter/material.dart';

bool? autherMedia;

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool? appEnabled;

  @override
  void initState() {
    super.initState();
    _checkAppStatus();
  }

  Future<void> _checkAppStatus() async {
    // Check local storage first for quick response
    bool enabled =
        await SecureStorage.getBoolean(key: 'diamate_enabled') ?? true;
    log('Initial app enabled status from SecureStorage: $enabled');

    try {
      // Use the already initialized RemoteConfigService from locator
      final remoteConfigService = sl<RemoteConfigService>();

      enabled = remoteConfigService.getBool('diamate_enabled');
      autherMedia = remoteConfigService.getBool('diamate_auther_media');

      log('Fetched app enabled status from Remote Config: $enabled');
      await SecureStorage.setBoolean(key: 'diamate_enabled', value: enabled);
    } catch (e) {
      log('Failed to read Remote Config from service: $e');
    }

    if (!mounted) return;

    setState(() {
      appEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('Building AppGate with appEnabled: $appEnabled');

    if (appEnabled == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    if (appEnabled == false) {
      return const LolView();
    }

    // Check auth status to decide whether to show Chatbot or Login
    return FutureBuilder<bool?>(
      future: SecureStorage.getBoolean(key: K.isLogged),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          return const ChatbotView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
