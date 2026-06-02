import 'package:get/get.dart';
import 'package:shoppex/data/local/secure_storage.dart';
import 'package:shoppex/shared/services/auth_service.dart';

class AccountController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userRole = 'Customer'.obs;

  var profileImageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb'.obs;

  bool get isAuthenticated => AuthService.to.hasToken;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    ever(AuthService.isAuthenticated, (_) => loadUserData());
  }

  void loadUserData() {
    if (isAuthenticated) {
      userName.value = SecureStorage.userName ?? 'Somonor Customer';
      userEmail.value = SecureStorage.userEmail ?? 'hsomonor@gmail.com';

      // 🟢 FIXED: Reads the saved server role directly from your SecureStorage cache
      userRole.value = SecureStorage.userRole ?? 'Customer';
    } else {
      // Clear data completely on guest view or sign out
      userName.value = '';
      userEmail.value = '';
      userRole.value = 'Customer';
    }
  }

  void onEditProfilePressed() {
    print("Edit Profile Clicked");
  }
}