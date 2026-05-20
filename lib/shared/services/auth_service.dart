import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import '../../data/local/secure_storage.dart';

class AuthService extends GetxService {
  static RxBool isAuthenticated = false.obs;
  static AuthService auth = Get.find<AuthService>();
  static RxString authToken = RxString('');
  final ApiClient _provider = Get.find<ApiClient>();

  @override
  void onInit() {
    _checkAuth();
    super.onInit();
  }

  void _checkAuth() async {
    final token = await SecureStorage.getToken();
    // ✅ Fixed Null check operator crash logic
    if (token != null && token.isNotEmpty) {
      isAuthenticated(true);
      authToken(token);
    } else {
      isAuthenticated(false);
    }
  }

  Future<void> logout() async {
    try {
      final res = await _provider.logout(authToken.value);

      // Checking for both 200 (OK) or 204 (No Content) depending on your API backend
      if (res.statusCode == 200 || res.statusCode == 204) {
        await SecureStorage.remove('token');

        // ✅ Reset the Auth States
        isAuthenticated(false);
        authToken('');

        // ✅ Redirect user back to login screen
        Get.offAllNamed('/sign_in');
      }
    } catch (e) {
      Get.defaultDialog(middleText: "Logout error: ${e.toString()}");
    }
  }

}