import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:developer';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    try {
      await _remoteConfig.setDefaults({
        'diamate_enabled': true,
        'diamate_auther_media': false,
      });

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _remoteConfig.fetchAndActivate();
      log('Remote Config initialized and activated');
    } catch (e) {
      log('Error initializing Remote Config: $e');
    }
  }

  bool getBool(String key) => _remoteConfig.getBool(key);
}
