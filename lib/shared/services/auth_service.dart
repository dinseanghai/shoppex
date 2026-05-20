import 'package:get/get.dart';
import '../../data/local/secure_storage.dart';

class AuthService extends GetxService{
  static RxBool isAuthenticated = false.obs;
  static AuthService auth = Get.find<AuthService>();
  @override
  void onInit() {
    // TODO: implement onInit
    _checkAuth();
    super.onInit();
  }

  void _checkAuth() async {
    final token = await SecureStorage.getToken();
    if(token != null || token!.isEmpty) {
      isAuthenticated(true);
    }
  }
<<<<<<< Updated upstream
=======

  Future<void> logout() async {
    try {
      final res = await _provider.logout(authToken.value);

      // Checking for both 200 (OK) or 204 (No Content) depending on your API backend
      if (res.statusCode == 200 || res.statusCode == 204) {

        // 💡 CHANGE THIS LINE: Remove 'token' from the parentheses
        await SecureStorage.remove();

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

>>>>>>> Stashed changes
}