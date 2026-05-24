import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_string.dart';


class Snackbars {
  static void closeAll() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  static void showSuccess() {
    closeAll();
    Get.rawSnackbar(
      title: AppStrings.backOnlineTitle,
      message: AppStrings.backOnlineMsg,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      overlayBlur: 0,
      // FIXED: Set to 0 so it slides down cleanly like ABA without jarring screen blurs
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.wifi, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 15,
    );
  }
}