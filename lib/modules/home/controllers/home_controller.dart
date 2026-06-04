import 'dart:ui';

import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';


class HomeController extends GetxController {
  var isLoading = false.obs;
  var notificationCount = 0.obs;
  var cartCount = 0.obs;

  // 🟢 Automatically reactive: If not authenticated, it's Guest Mode
  bool get isGuestMode => !AuthService.isAuthenticated.value;

  bool get isVendor {
    final role = AuthService.userRole.value.trim().toLowerCase();
    return role == 'vendor' || role == 'vender';
  }

  @override
  void onInit() {
    super.onInit();
    // 🟢 Use ever() to listen to authentication changes dynamically
    ever(AuthService.isAuthenticated, (_) => checkUserStatus());
    checkUserStatus();
  }

  void checkUserStatus() {
    if (isGuestMode) {
      notificationCount.value = 0;
      cartCount.value = 0;
    } else {
      // Fetch actual data for signed-in users here
      notificationCount.value = 1;
      cartCount.value = 3;
    }
  }

  // 🟢 This method protects your actions seamlessly
  void handleProtectedAction(VoidCallback onUserApproved) {
    if (isGuestMode) {
      Get.toNamed(Routes.SIGNIN); // Use .toNamed so they can press 'back' if they want to return to browsing as guest
    } else {
      onUserApproved();
    }
  }


  void onNotificationClick() {
    handleProtectedAction(() {
      //Get.toNamed(Routes.NOTIFICATIONS);
    });
  }

  void onCartClick() {
    handleProtectedAction(() {
      if (Get.isRegistered<MainLayoutController>()) {
        final mainLayoutController = Get.find<MainLayoutController>();

        mainLayoutController.changeTab(1);
      } else {
        //Get.toNamed(Routes.CART);
      }
    });
  }

  void onAddToFavoriteClick() {
    handleProtectedAction(() {
      // Your favorite logic here
      Get.snackbar("Success", "Added to favorites!");
    });
  }
}