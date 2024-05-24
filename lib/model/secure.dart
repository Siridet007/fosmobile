import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const String usernameKey = 'username';
  static const String passwordKey = 'password';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: usernameKey, value: username);
    await _storage.write(key: passwordKey, value: password);
  }

  static Future<Map<String, String>> getCredentials() async {
    String? username = await _storage.read(key: usernameKey);
    String? password = await _storage.read(key: passwordKey);

    return {
      usernameKey: username ?? '',
      passwordKey: password ?? '',
    };
  }

  static Future<void> deleteCredentials() async {
    await _storage.delete(key: usernameKey);
    await _storage.delete(key: passwordKey);
  }
}
