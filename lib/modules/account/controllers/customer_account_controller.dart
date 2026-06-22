import 'package:flutter/material.dart';
import 'package:shoppex/modules/account/controllers/base_account_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/services/auth_service.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../home/controllers/base_home_controller.dart';

class CustomerAccountController extends BaseAccountController {

  void onEditProfilePressed() {
    print("Edit Profile Clicked for User ID: ${userId.value}");
  }

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
        Get.back();
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
          await Future.delayed(const Duration(milliseconds: 800));

          // 1. Clear local storage/tokens
          await AuthService.to.logout();

          // 2. Reset the MainLayoutController state
          if (Get.isRegistered<MainLayoutController>()) {
            final mainLayout = Get.find<MainLayoutController>();
            mainLayout.isLoggedIn.value = false;
            mainLayout.currentIndex.value = 0;
            mainLayout.userName.value = 'Guest';
          }

          // 🟢 Simplified: Everyone goes straight back to the MAIN_LAYOUT
          Get.offAllNamed(Routes.MAIN_LAYOUT);

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