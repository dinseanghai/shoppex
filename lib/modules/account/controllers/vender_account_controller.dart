import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/widgets/loading_widget.dart';
import 'base_account_controller.dart';

class VenderAccountController extends BaseAccountController {

  void confirmLogout() {
    Get.defaultDialog(
      title: "Are you sure you want to sign out?",
      middleText: "Signing out will temporarily hide all your personal data. To see these again, just log back into your account.",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
      titlePadding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      onConfirm: () {
        Get.back(); // Closes the dialog smoothly first
        logout();
      },
    );
  }

  void logout() async {
    Get.showOverlay(
      loadingWidget: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const LoadingWidget(
            size: 50.0,
            isButtonMode: false,
          ),
        ),
      ),
      opacity: 0.3,
      opacityColor: Colors.black,
      asyncFunction: () async {
        try {
          // 1. Clear local storage/tokens
          await AuthService.to.logout();

          // 🟢 THE SMOOTHNESS FIX:
          // Give the Flutter engine 100 milliseconds to settle the reactive state changes
          // (clearing username, changing Rx values) BEFORE moving screens.
          // This removes UI stuttering or sudden screen flashing completely.
          await Future.delayed(const Duration(milliseconds: 100));

        } catch (e) {
          Get.snackbar(
            "Logout Failed",
            e.toString(),
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}