import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._internal();

  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getString({required String key}) async {
    return await _storage.read(key: key);
  }

  static Future<void> setBoolean({
    required String key,
    required bool value,
  }) async {
    await _storage.write(key: key, value: value.toString());
  }

  static Future<bool?> getBoolean({required String key}) async {
    final value = await _storage.read(key: key);
    // if(value?.toLowerCase() == 'null' || value == null) return null;
    return value?.toLowerCase() == 'true';
  }

  static Future<void> removeData({required String key}) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
