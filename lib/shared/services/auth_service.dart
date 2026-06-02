import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/local/secure_storage.dart';
import '../../routes/app_pages.dart';


class AuthService extends GetxService {
  static final isAuthenticated = false.obs;
  static final authToken = ''.obs;

  // Reactive UI variables linked directly to your Storage caches
  static final userName = ''.obs;
  static final userEmail = ''.obs;
  static final userRole = ''.obs;

  final ApiClient _provider = Get.find<ApiClient>();

  static AuthService get to => Get.find<AuthService>();

  /// Call this in main() during startup
  Future<void> initAuth() async {
    await SecureStorage.init();

    if (SecureStorage.hasToken) {
      isAuthenticated.value = true;
      authToken.value = SecureStorage.token ?? '';

      // Load cached strings into reactive variables for the UI
      userName.value = SecureStorage.userName ?? '';
      userEmail.value = SecureStorage.userEmail ?? '';
      userRole.value = SecureStorage.userRole ?? '';
    } else {
      _clearAuthState();
    }
  }

  bool get hasToken => isAuthenticated.value && authToken.value.isNotEmpty;

  /// Handles the exact response mapping
  Future<void> handleLoginSuccess(Map<String, dynamic> jsonResponse) async {
    try {
      final token = jsonResponse['token'] as String?;
      final user = jsonResponse['user'] as Map<String, dynamic>?;

      if (token != null && token.isNotEmpty) {
        // 1. Write token to storage & cache
        await SecureStorage.writeToken(token);
        authToken.value = token;
        isAuthenticated.value = true;

        if (user != null) {
          final name = user['name'] as String? ?? '';
          final email = user['email'] as String? ?? '';

          // Your API returns a roles array: ["Customer"]. We take the first one safely.
          final rolesList = user['roles'] as List<dynamic>?;
          final role = (rolesList != null && rolesList.isNotEmpty)
              ? rolesList.first.toString()
              : '';

          // 2. Write User Data to storage & cache
          await SecureStorage.writeUserData(name: name, email: email, role: role);

          // 3. Update reactive states for the UI
          userName.value = name;
          userEmail.value = email;
          userRole.value = role;
        }

        // 4. Send them on their way
        Get.offAllNamed(Routes.HOME);
      } else {
        throw Exception("Token missing from API payload.");
      }
    } catch (e) {
      Get.defaultDialog(middleText: "Session Initialization Error: ${e.toString()}");
    }
  }

  Future<void> logout() async {
    try {
      final res = await _provider.logout(authToken.value);

      if (res.statusCode == 200 || res.statusCode == 204) {
        await SecureStorage.remove();
        _clearAuthState();
        Get.offAllNamed(Routes.SIGNIN);
      }
    } catch (e) {
      Get.defaultDialog(middleText: "Logout error: ${e.toString()}");
    }
  }

  void _clearAuthState() {
    isAuthenticated.value = false;
    authToken.value = '';
    userName.value = '';
    userEmail.value = '';
    userRole.value = '';
  }
}