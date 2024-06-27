import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeToken(String token) async {
    const String key = 'auth_token';
    await _storage.write(key: key, value: token);
  }

  Future<String?> readToken() async {
    const String key = 'auth_token';
    return await _storage.read(key: key);
  }

  Future<void> deleteToken() async {
    const String key = 'auth_token';
    await _storage.delete(key: key);
  }
}
