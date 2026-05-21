import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/local/secure_storage.dart';
import '../../routes/app_pages.dart';

import 'package:get/get.dart';
// Import your AppPages / Routes / ApiClient / SecureStorage here

class AuthService extends GetxService {
  static final isAuthenticated = false.obs;
  static final authToken = ''.obs;

  final ApiClient _provider = Get.find<ApiClient>();

  static AuthService get to => Get.find<AuthService>();

  /// Call this in main() during startup to bootstrap the Auth state
  Future<void> initAuth() async {
    // ✅ FIX: Force SecureStorage to read the hardware disk *before* checking credentials!
    await SecureStorage.init();

    if (SecureStorage.hasToken) {
      isAuthenticated.value = true;
      authToken.value = SecureStorage.token ?? '';
    } else {
      isAuthenticated.value = false;
      authToken.value = '';
    }
  }

  /// Synchronous helper for your Middleware
  bool get hasToken => isAuthenticated.value && authToken.value.isNotEmpty;

  Future<void> logout() async {
    try {
      final res = await _provider.logout(authToken.value);

      if (res.statusCode == 200 || res.statusCode == 204) {
        await SecureStorage.remove();

        // Reset states cleanly
        isAuthenticated.value = false;
        authToken.value = '';

        Get.offAllNamed(Routes.SIGNIN);
      }
    } catch (e) {
      Get.defaultDialog(middleText: "Logout error: ${e.toString()}");
    }
  }
}