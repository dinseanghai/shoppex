import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_string.dart';


class Snackbars {
  static void closeAll() {
    if (Get.isSnackbarOpen) {
      try {
        Get.back();
      } catch (e) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  /// Helper method to keep glassmorphism styling consistent across all snackbars
  static void _showGlassSnackbar({
    required String title,
    required String message,
    required Color baseColor, // The tint color for the glass effect
    IconData? icon,
  }) {
    closeAll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.rawSnackbar(
        titleText: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        messageText: Text(
          message,
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        icon: icon != null ? Icon(icon, color: Colors.white) : null,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderRadius: 16,

        // --- GLASSMORPHISM ESSENTIALS ---
        overlayBlur: 4.0, // Blurs the screen behind the snackbar (Optional)
        barBlur: 20.0,    // Blurs what's directly underneath the snackbar container

        // Removed gradient: Using a solid bright color with alpha opacity for the glass tint
        backgroundColor: baseColor,

        // A subtle, soft border to define the glass edges
        borderColor: Colors.white.withOpacity(0.3),
        borderWidth: 1.5,
      );
    });
  }

  // --- REFACTORED METHODS ---

  static void showBackOnline() {
    _showGlassSnackbar(
      title: AppStrings.backOnlineTitle,
      message: AppStrings.backOnlineMsg,
      // Using a vivid, bright green with 0.65 opacity to make it pop over the blur
      baseColor: const Color(0xFF03C560).withOpacity(0.65),
      icon: Icons.wifi,
    );
  }

  static void verifyOtp() {
    _showGlassSnackbar(
      title: 'Error',
      message: AppStrings.otpdigits,
      baseColor: Color(0xFFEF0000).withOpacity(0.6),
    );
  }

  static void resendotp() {
    _showGlassSnackbar(
      title: 'Success',
      message: AppStrings.resendotp,
      baseColor: Color(0xFF03C560).withOpacity(0.65),
    );
  }

  static void invalidotp() {
    _showGlassSnackbar(
      title: 'Error',
      message: 'The OTP is Invalid',
      baseColor: Color(0xFFEF0000).withOpacity(0.6),
    );
  }

  static void optexpired() {
    _showGlassSnackbar(
      title: 'Code Expired',
      message: AppStrings.optexpired,
      baseColor: Color(0xFF03C560).withOpacity(0.65),
    );
  }
}