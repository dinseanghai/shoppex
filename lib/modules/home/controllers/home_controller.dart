import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var deliveryLocation = 'Toul Kork, Phnom Penh'.obs;

  void changeLocation() {
    // Logic to open a location picker
    print("Location selector tapped");
  }

  void executeSearch(String query) {
    print("Searching for: $query");
  }

  void openFilters() {
    print("Filter settings tapped");
  }

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

      // 1. Clear local storage authentication tokens globally
      await AuthService.to.logout();

      // ⭐ CRITICAL FIX FOR GUEST MODE: WIPE THE LAYOUT STATE
      // Reset the MainLayoutController login flag before shifting screens
      if (Get.isRegistered<MainLayoutController>()) {
        final mainLayout = Get.find<MainLayoutController>();
        mainLayout.isLoggedIn.value = false;
        mainLayout.currentIndex.value = 0; // Reset tab view position back to home tab
      }

      // 2. Cleanly wipe the screen stacks and return to Sign In view
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