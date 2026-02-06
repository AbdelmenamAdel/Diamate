import 'dart:developer';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/utils/mini/lol_view.dart';
import 'package:diamate/features/main/presentation/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

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
    // Using SecureStorage instead of SharedPreferences
    bool enabled =
        await SecureStorage.getBoolean(key: 'diamate_enabled') ?? true;

    log('Initial app enabled status from SecureStorage: $enabled');
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 8),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await remoteConfig.fetchAndActivate();
      enabled = remoteConfig.getBool('diamate_enabled');
      autherMedia = remoteConfig.getBool('diamate_auther_media');

      log('Fetched app enabled status from Remote Config: $enabled');
      await SecureStorage.setBoolean(key: 'diamate_enabled', value: enabled);
    } catch (e) {
      log(
        'Failed to fetch Remote Config, using cached value: $enabled. Error: $e',
      );
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

    // Navigating to MainView
    return const MainView();
  }
}
