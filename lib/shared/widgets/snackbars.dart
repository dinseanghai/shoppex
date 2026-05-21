import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_string.dart';


class Snackbars {
  static void closeAll() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  static void showNetworkError(String message) {
    closeAll();
    Get.rawSnackbar(
      title: "No Connection",
      message: message,
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.TOP,
      overlayBlur: 5,
      duration: const Duration(days: 1), // Keep open until online again
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 15,
    );
  }

  static void showSuccess() {
    closeAll();
    Get.rawSnackbar(
      title: AppStrings.backOnlineTitle,
      message: AppStrings.backOnlineMsg,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
      overlayBlur: 5,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.wifi, color: Colors.white),
      margin: const EdgeInsets.all(10),
      borderRadius: 15,
    );
  }


  static void showWelcomeBack(String userName) {
    // Optional: Close any existing snackbars so they don't stack up
    closeAll();

    Get.rawSnackbar(
      // We use messageText to completely customize the row structure
      messageText: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flutter logo container matching your screenshot
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const FlutterLogo(size: 18),
          ),
          const SizedBox(width: 12),
          // Welcome text
          Text(
            "Welcome Back, $userName",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF424242).withOpacity(0.9), // Smooth dark gray background
      snackPosition: SnackPosition.BOTTOM,
      maxWidth: 280, // Restricts width to make it a small pill layout instead of stretching full width
      margin: const EdgeInsets.only(bottom: 50), // Lifts it up slightly from the system navigation bar
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 30, // Highly rounded corners to make it a perfect pill
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}