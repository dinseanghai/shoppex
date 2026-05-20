import 'package:get/get.dart';
import 'package:shoppex/routes/app_pages.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import 'core/network/api_client.dart';
import 'data/local/secure_storage.dart';

class DependencyInjection {
  static final isAuthenticated = false.obs;

  static Future<void> init() async {
    Get.put(ApiClient(), permanent: true);
    Get.put(SecureStorage(), permanent: true);
    Get.put(AuthService(), permanent: true);

    final String? token = await SecureStorage.getToken();
    isAuthenticated.value = token != null && token.isNotEmpty;
  }

  /// Call this function from any controller or logout button in your app
  static Future<void> logout() async {
    // 1. Completely remove the token from device memory
    await SecureStorage.remove();

    // 2. Clear out your global reactive state
    isAuthenticated.value = false;

    // 3. Clear the navigation history stack and force push the Login layout
    Get.offAllNamed(Routes.SIGNIN);
  }
}