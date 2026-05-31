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

  static void _showGlassSnackbar({
    required String title,
    required String message,
    required Color baseColor, // Directly accepts your custom color + opacity tint!
    IconData? icon,
  }) {
    closeAll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.rawSnackbar(
        titleText: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
          ),
        ),

        // The icon inherits white to stay clean against your tinted background
        icon: icon != null ? Icon(icon, color: Colors.white, size: 22) : null,

        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        borderRadius: 20,

        // --- THE BLUR EFFECTS ---
        barBlur: 25.0,       // Frosted glass blend
        overlayBlur: 5.0,    // Blurs the entire app background beautifully

        // --- TINTED GLASS GRADIENT ---
        // We use your baseColor tint as the main layer, blending it slightly
        // to a slightly deeper alpha at the bottom to give it a clean glass gradient depth.
        backgroundGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor, // Your exact color & opacity (e.g., Color(0xFF03C560).withOpacity(0.65))
            baseColor.withOpacity(
                (baseColor.opacity - 0.15).clamp(0.0, 1.0) // Keeps it dynamic and slightly lighter at the bottom
            ),
          ],
          stops: const [0.0, 1.0],
        ),

        // Crisp, clean light-catching border
        borderColor: Colors.white.withOpacity(0.25),
        borderWidth: 1.0,

        // Premium ambient shadow to lift it forward over the background blur
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      );
    });
  }

  static void showBackOnline() {
    _showGlassSnackbar(
      title: AppStrings.backOnlineTitle,
      message: AppStrings.backOnlineMsg,
      // Using a vivid, bright green with 0.65 opacity to make it pop over the blur
      baseColor: const Color(0xFF03C560).withOpacity(0.5),
      icon: Icons.wifi,
    );
  }

  static void verifyOtp() {
    _showGlassSnackbar(
      title: 'Error',
      message: AppStrings.otpdigits,
      baseColor: Color(0xFFEF0000).withOpacity(0.5),
    );
  }

  static void resendotp() {
    _showGlassSnackbar(
      title: 'Success',
      message: AppStrings.resendotp,
      baseColor: Color(0xFF03C560).withOpacity(0.5),
    );
  }

  static void invalidotp() {
    _showGlassSnackbar(
      title: 'Error',
      message: 'The OTP is Invalid',
      baseColor: Color(0xFFEF0000).withOpacity(0.5),
    );
  }

  static void optexpired() {
    _showGlassSnackbar(
      title: 'Code Expired',
      message: AppStrings.optexpired,
      baseColor: Color(0xFF03C560).withOpacity(0.5),
    );
  }

  static void resetotp() {
    _showGlassSnackbar(
      title: 'Success',
      message: AppStrings.resetotp,
      baseColor: Color(0xFF03C560).withOpacity(0.5),
    );
  }
}