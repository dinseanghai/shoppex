import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorage extends GetxService {
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static Future<void> write(String value) async {
    await storage.write(key: 'token', value: value);
  }

<<<<<<< Updated upstream
  static void remove(String value) async {
=======
  // 💡 Update this method: Remove the 'String value' parameter
  static Future<void> remove() async {
>>>>>>> Stashed changes
    await storage.delete(key: 'token');
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}