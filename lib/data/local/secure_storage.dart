import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorage extends GetxService {
  static const _storage = FlutterSecureStorage();
  static String? _cachedToken;
  static int? _cachedId; // 🟢 Added user ID cache variable (int)
  static String? _cachedName;
  static String? _cachedEmail;
  static String? _cachedRole;
  static String? _cachedImageUrl;

  static Future<void> init() async {
    _cachedToken = await _storage.read(key: 'token');

    // 🟢 Read string from storage and parse it to int (or default to null)
    final savedId = await _storage.read(key: 'user_id');
    _cachedId = savedId != null ? int.tryParse(savedId) : null;

    _cachedName = await _storage.read(key: 'user_name');
    _cachedEmail = await _storage.read(key: 'user_email');
    _cachedRole = await _storage.read(key: 'user_role');
    _cachedImageUrl = await _storage.read(key: 'user_image_url');
  }

  static bool get hasToken => _cachedToken != null && _cachedToken!.isNotEmpty;

  static String? get token => _cachedToken;
  static int? get userId => _cachedId; // 🟢 Added public getter for user ID as an int
  static String? get userName => _cachedName;
  static String? get userEmail => _cachedEmail;
  static String? get userRole => _cachedRole;
  static String? get userImageUrl => _cachedImageUrl;

  /// Renamed to writeToken to distinguish it from writeUserData
  static Future<void> writeToken(String value) async {
    await _storage.write(key: 'token', value: value);
    _cachedToken = value;
  }

  static Future<void> writeUserData({
    required int id, // 🟢 Added named parameter for user ID (int)
    required String name,
    required String email,
    required String role,
    required String image,
  }) async {
    // 🟢 Persist ID converted to String because secure storage requires String values
    await _storage.write(key: 'user_id', value: id.toString());
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_role', value: role);
    await _storage.write(key: 'user_image_url', value: image);

    _cachedId = id; // 🟢 Sync local integer cache pointer
    _cachedName = name;
    _cachedEmail = email;
    _cachedRole = role;
    _cachedImageUrl = image;
  }

  static Future<void> remove() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_id'); // 🟢 Evict user ID key from disk
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_role');
    await _storage.delete(key: 'user_image_url');

    _cachedToken = null;
    _cachedId = null; // 🟢 Purge runtime ID pointer reference
    _cachedName = null;
    _cachedEmail = null;
    _cachedRole = null;
    _cachedImageUrl = null;
  }
}