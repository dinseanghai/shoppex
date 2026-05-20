import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  // 1. Call this from your UI button instead of the old logout()
  void confirmLogout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to sign out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close the dialog immediately
        logout(); // Run the actual async logout process
      },
    );
  }

  // 2. Make the actual logout method private so it's safely guarded by the dialog
  void logout() async {
    try {
      isLoading(true);
      // Await the logout process so finally{} doesn't execute too early
      await AuthService.auth.logout();
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
    } finally {
      isLoading(false);
    }
  }
}