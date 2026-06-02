import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorage extends GetxService {
  static const _storage = FlutterSecureStorage();
  static String? _cachedToken;
  static String? _cachedName;
  static String? _cachedEmail;
  static String? _cachedRole; // 🟢 NEW: Static cache field for user role

  static Future<void> init() async {
    _cachedToken = await _storage.read(key: 'token');
    _cachedName = await _storage.read(key: 'user_name');
    _cachedEmail = await _storage.read(key: 'user_email');
    _cachedRole = await _storage.read(key: 'user_role'); // 🟢 NEW: Read role from disk on startup
  }

  static bool get hasToken {
    final exists = _cachedToken != null && _cachedToken!.isNotEmpty;
    return exists;
  }

  static String? get token => _cachedToken;
  static String? get userName => _cachedName;
  static String? get userEmail => _cachedEmail;
  static String? get userRole => _cachedRole; // 🟢 NEW: Getter matching your style

  static Future<void> write(String value) async {
    await _storage.write(key: 'token', value: value);
    _cachedToken = value;
  }

  // 🟢 ADJUSTED: Accept 'role' and save it alongside name and email
  static Future<void> writeUserData({
    required String name,
    required String email,
    required String role, // Added role parameter
  }) async {
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_role', value: role); // Save role to hardware disk

    _cachedName = name;
    _cachedEmail = email;
    _cachedRole = role; // Save to RAM cache
  }

  static Future<void> remove() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_role'); // 🟢 NEW: Clear role on disk

    _cachedToken = null;
    _cachedName = null;
    _cachedEmail = null;
    _cachedRole = null; // 🟢 NEW: Clear role in RAM cache
  }
}