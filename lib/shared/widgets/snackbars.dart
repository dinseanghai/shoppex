import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_string.dart';


class Snackbars {
  static void closeAll() {
    // A much safer way to close active snackbars/overlays in GetX
    // without triggering the uninitialized late variable error.
    if (Get.isSnackbarOpen) {
      try {
        Get.back(); // Safely pops the top overlay layer if it's a snackbar/dialog
      } catch (e) {
        // Fallback catch-all to prevent crashes if GetX state is desynced
        Get.closeCurrentSnackbar();
      }
    }
  }

  static void showSuccess() {
    closeAll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.rawSnackbar(
        title: AppStrings.backOnlineTitle,
        message: AppStrings.backOnlineMsg,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        overlayBlur: 0,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.wifi, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 15,
      );
    });
  }
}