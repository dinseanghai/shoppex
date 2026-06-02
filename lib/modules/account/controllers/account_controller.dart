import 'package:get/get.dart';
import 'package:shoppex/data/local/secure_storage.dart';
import 'package:shoppex/shared/services/auth_service.dart';

class AccountController extends GetxController {

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userRole = 'Customer'.obs;

  var profileImageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb'.obs;

  bool get isAuthenticated => AuthService.to.hasToken;

  // 🟢 Added: Helper getter to easily switch UI layouts in AccountView
  bool get isVendor =>
      userRole.value.toLowerCase() == 'vendor' ||
          userRole.value.toLowerCase() == 'vender';

  @override
  void onInit() {
    super.onInit();
    loadUserData();

    // Listen to authentication status updates globally
    ever(AuthService.isAuthenticated, (_) => loadUserData());

    // 🟢 Added: Listen explicitly to global role updates so the view redraws instantly
    // the very split-second a login completes.
    ever(AuthService.userRole, (String updatedRole) {
      userRole.value = updatedRole.isNotEmpty ? updatedRole : 'Customer';
    });
  }

  void loadUserData() {
    if (isAuthenticated) {
      // 🟢 ADJUSTED: Pull directly from the live, reactive AuthService variables
      userName.value = AuthService.userName.value;
      userEmail.value = AuthService.userEmail.value;
      userRole.value = AuthService.userRole.value.isNotEmpty
          ? AuthService.userRole.value
          : 'Customer';
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