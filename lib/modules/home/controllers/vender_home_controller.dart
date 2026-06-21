import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';

import 'base_home_controller.dart';

class VenderController extends BaseHomeController {
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = 'Customer'.obs;
  final userImageUrl = ''.obs;

  final availableBalance = 4128.50.obs;
  final pendingBalance = 312.00.obs;

  bool get isAuthenticated => AuthService.to.hasToken;

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning 👋';
    } else if (hour < 17) {
      return 'Good Afternoon 👋';
    } else if (hour < 21) {
      return 'Good Evening 👋';
    } else {
      return 'Good Night 🌙';
    }
  }

  bool get isVender {
    final role = userRole.value.trim().toLowerCase();
    return  role == 'vendor' || role == 'vender';
  }

  @override
  void onInit() {
    super.onInit();
    _syncWithAuthService();

    ever(AuthService.userName, (String name) => userName.value = name);
    ever(AuthService.userEmail, (String email) => userEmail.value = email);
    ever(AuthService.userImageUrl, (String url) => userImageUrl.value = url.trim());
    ever(AuthService.userRole, (String role) {
      userRole.value = role.trim().isNotEmpty ? role.trim() : 'Customer';
    });

    ever(AuthService.isAuthenticated , (bool loggedIn) {
      if(!loggedIn) {
        _clearUserData();
      } else {
        _syncWithAuthService();
      }
    });

  }

  void _syncWithAuthService() {
    if (isAuthenticated) {
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

  void _clearUserData() {
    userName.value = '';
    userEmail.value = '';
    userImageUrl.value = '';
    userRole.value = 'Customer';
  }

  void onWithdrawTap() {
    Get.snackbar(
      'Withdraw',
      'Withdraw feature coming soon',
    );
  }
}