import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorage extends GetxService {
  static final storage = FlutterSecureStorage();

  static void write(String value) async {
    await storage.write(key: 'token', value: value);
  }

  static void remove(String value) async {
    await storage.delete(key: 'token');
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

}