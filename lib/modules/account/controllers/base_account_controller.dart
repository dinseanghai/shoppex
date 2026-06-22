import 'package:get/get.dart';

import '../../../shared/services/auth_service.dart';

class BaseAccountController extends GetxController {
  final userId = 0.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = 'Customer'.obs;
  final userImageUrl = ''.obs;

  // Clean, descriptive getters
  bool get isAuthenticated => AuthService.to.hasToken;

  bool get isVendor {
    final role = userRole.value.trim().toLowerCase();
    return role == 'vendor' || role == 'vender';
  }

  @override
  void onInit() {
    super.onInit();

    // Initial sync
    _syncWithAuthService();

    // 🟢 Stream types match perfectly now: RxInt to RxInt
    ever(AuthService.userId, (int id) => userId.value = id);

    ever(AuthService.userName, (String name) => userName.value = name);
    ever(AuthService.userEmail, (String email) => userEmail.value = email);
    ever(AuthService.userImageUrl, (String url) => userImageUrl.value = url.trim());

    ever(AuthService.userRole, (String role) {
      userRole.value = role.trim().isNotEmpty ? role.trim() : 'Customer';
    });

    ever(AuthService.isAuthenticated, (bool loggedIn) {
      if (!loggedIn) {
        _clearUserData();
      } else {
        _syncWithAuthService();
      }
    });
  }

  void _syncWithAuthService() {
    if (isAuthenticated) {
      userId.value = AuthService.userId.value; // 🟢 Directly assign int values
      userName.value = AuthService.userName.value;
      userEmail.value = AuthService.userEmail.value;
      userImageUrl.value = AuthService.userImageUrl.value.trim();
      userRole.value = AuthService.userRole.value.trim().isNotEmpty
          ? AuthService.userRole.value.trim()
          : 'Customer';
    } else {
      _clearUserData();
    }
  }

  /// Helper logic to purge state safely on logout or anonymous sessions
  void _clearUserData() {
    userId.value = 0; // 🟢 Reset to default integer
    userName.value = '';
    userEmail.value = '';
    userImageUrl.value = '';
    userRole.value = 'Customer';
  }

}