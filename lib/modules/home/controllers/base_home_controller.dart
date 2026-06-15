import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/network_service.dart';

class BaseHomeController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final NetworkService networkService = Get.find<NetworkService>();

  // Role switch
  final isVendor = false.obs;

  bool get isGuestMode => !AuthService.isAuthenticated.value;

  @override
  void onInit() {
    super.onInit();

    _updateRole();

    ever(AuthService.userRole, (_) => _updateRole());
  }

  void _updateRole() {
    final role = AuthService.userRole.value.trim().toLowerCase();
    isVendor.value = role == 'vendor' || role == 'vender';
  }

  Future<void> requireLogin(Future<void> Function() action) async {
    if (isGuestMode) {
      Get.toNamed(Routes.SIGNIN);
      return;
    }
    await action();
  }
}