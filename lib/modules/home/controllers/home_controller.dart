import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';

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

  void logout() async {
    try {
      isLoading(true);
      await AuthService.to.logout();
    } catch (e) {
      // Only show error dialogs if the screen is still active
      if (Get.isRegistered<HomeController>()) {
        Get.defaultDialog(middleText: e.toString());
      }
    } finally {
      // ✅ FIX: Only update state if this controller wasn't destroyed by Get.offAllNamed()
      if (Get.isRegistered<HomeController>()) {
        isLoading(false);
      }
    }
  }
}