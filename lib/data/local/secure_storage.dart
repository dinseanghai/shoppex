import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorage extends GetxService {
  static const _storage = FlutterSecureStorage();
  static String? _cachedToken;

  static Future<void> init() async {
    _cachedToken = await _storage.read(key: 'token');

  }

  static bool get hasToken {
    final exists = _cachedToken != null && _cachedToken!.isNotEmpty;

    return exists;
  }

  static String? get token => _cachedToken;

  static Future<void> write(String value) async {
    await _storage.write(key: 'token', value: value);
    _cachedToken = value;

  }

  static Future<void> remove() async {
    await _storage.delete(key: 'token');
    _cachedToken = null;

  }
}