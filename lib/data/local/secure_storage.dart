import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorage extends GetxService {
  static const _storage = FlutterSecureStorage();
  static String? _cachedToken;
  static String? _cachedName;
  static String? _cachedEmail;
  static String? _cachedRole;

  static Future<void> init() async {
    _cachedToken = await _storage.read(key: 'token');
    _cachedName = await _storage.read(key: 'user_name');
    _cachedEmail = await _storage.read(key: 'user_email');
    _cachedRole = await _storage.read(key: 'user_role');
  }

  static bool get hasToken => _cachedToken != null && _cachedToken!.isNotEmpty;

  static String? get token => _cachedToken;
  static String? get userName => _cachedName;
  static String? get userEmail => _cachedEmail;
  static String? get userRole => _cachedRole;

  /// Renamed to writeToken to distinguish it from writeUserData
  static Future<void> writeToken(String value) async {
    await _storage.write(key: 'token', value: value);
    _cachedToken = value;
  }

  static Future<void> writeUserData({
    required String name,
    required String email,
    required String role,
  }) async {
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_role', value: role);

    _cachedName = name;
    _cachedEmail = email;
    _cachedRole = role;
  }

  static Future<void> remove() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_role');

    _cachedToken = null;
    _cachedName = null;
    _cachedEmail = null;
    _cachedRole = null;
  }
}