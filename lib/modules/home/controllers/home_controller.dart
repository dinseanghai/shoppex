import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  void confirmLogout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        logout();
      },
    );
  }

  // inside your HomeController
  void logout() async {
    try {
      isLoading(true);
      await AuthService.to.logout(); // Clears your local storage auth tokens

      // ✅ Cleanly wipe the screen stacks and return to Sign In view
      Get.offAllNamed(Routes.SIGNIN);

    } catch (e) {
      if (Get.isRegistered<HomeController>()) {
        Get.defaultDialog(middleText: e.toString());
      }
    } finally {
      if (Get.isRegistered<HomeController>()) {
        isLoading(false);
      }
    }
  }
}