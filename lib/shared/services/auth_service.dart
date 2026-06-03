import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../data/local/secure_storage.dart';
import '../../routes/app_pages.dart';


class AuthService extends GetxService {
  static final isAuthenticated = false.obs;
  static final authToken = ''.obs;
  static final userId = 0.obs; // 🟢 Kept as 0.obs (RxInt) to match the integer 165

  // Reactive UI variables linked directly to your Storage caches
  static final userName = ''.obs;
  static final userEmail = ''.obs;
  static final userRole = ''.obs;
  static final userImageUrl = ''.obs;

  final ApiClient _provider = Get.find<ApiClient>();

  static AuthService get to => Get.find<AuthService>();

  /// Call this in main() during startup
  Future<void> initAuth() async {
    await SecureStorage.init();

    if (SecureStorage.hasToken) {
      isAuthenticated.value = true;
      authToken.value = SecureStorage.token ?? '';

      // 🟢 Load cached integer ID (Make sure to implement SecureStorage.userId getter returning int?)
      userId.value = SecureStorage.userId ?? 0;

      // Load cached strings into reactive variables for the UI
      userName.value = SecureStorage.userName ?? '';
      userEmail.value = SecureStorage.userEmail ?? '';
      userRole.value = SecureStorage.userRole ?? '';
      userImageUrl.value = SecureStorage.userImageUrl ?? '';
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
          // 🟢 1. Extract the user ID safely as an Integer
          final id = user['id'] is int
              ? user['id'] as int
              : int.tryParse(user['id'].toString()) ?? 0;

          final name = user['name'] as String? ?? '';
          final email = user['email'] as String? ?? '';

          // Note: Your JSON snippet uses 'avatar', adjusted to map cleanly
          final image = (user['avatar'] ?? user['image_url']) as String? ?? '';

          // Your API returns a roles array: ["Vender"]. We take the first one safely.
          final rolesList = user['roles'] as List<dynamic>?;
          final role = (rolesList != null && rolesList.isNotEmpty)
              ? rolesList.first.toString()
              : '';

          // 2. Write User Data to storage & cache
          // 🟢 Note: Update SecureStorage.writeUserData signature to accept 'id' (int)
          await SecureStorage.writeUserData(
            id: id,
            name: name,
            email: email,
            role: role,
            image: image,
          );

          // 3. Update reactive states for the UI
          userId.value = id;         // 🟢 Streams the integer 165 instantly to AccountController
          userName.value = name;
          userEmail.value = email;
          userRole.value = role;
          userImageUrl.value = image;
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
    userId.value = 0;       // 🟢 Reset integer state safely on logout
    userName.value = '';
    userEmail.value = '';
    userRole.value = '';
    userImageUrl.value = '';
  }
}