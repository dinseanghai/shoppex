import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_string.dart';


class Snackbars {
  Snackbars._();

  // 1. Add the closeAll method here
  static void closeAll() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  static void showNetworkError(String message) {
    if (Get.isSnackbarOpen) return;

    Get.rawSnackbar(
      title: AppStrings.noConnectionTitle,
      message: message,
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.TOP,
      isDismissible: false,
      overlayBlur: 5,
      duration: const Duration(days: 1), // Keeps it visible until fixed
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      shouldIconPulse: true,
      margin: EdgeInsets.all(10),
      borderRadius: 15,
    );
  }

  static void showSuccess() {
    // We close the "No Connection" one before showing "Back Online"
    closeAll();

    Get.rawSnackbar(
      title: AppStrings.backOnlineTitle,
      message: AppStrings.backOnlineMsg,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      overlayBlur: 5,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.wifi, color: Colors.white),
      margin: EdgeInsets.all(10),
      borderRadius: 15,
    );
  }
}