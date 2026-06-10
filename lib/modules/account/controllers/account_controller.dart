import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/services/auth_service.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../home/controllers/home_controller.dart';

class AccountController extends GetxController {
  // Reactive UI variables
  final userId = 0.obs; // 🟢 Changed back to 0.obs (RxInt) to match AuthService exactly
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = 'Customer'.obs;
  final userImageUrl = ''.obs;

  // Clean, descriptive getters
  bool get isAuthenticated => AuthService.to.hasToken;

  bool get isVendor {
    final role = userRole.value.trim().toLowerCase();
    return role == 'vendor' || role == 'vender';
  }

  @override
  void onInit() {
    super.onInit();

    // Initial sync
    _syncWithAuthService();

    // 🟢 Stream types match perfectly now: RxInt to RxInt
    ever(AuthService.userId, (int id) => userId.value = id);

    ever(AuthService.userName, (String name) => userName.value = name);
    ever(AuthService.userEmail, (String email) => userEmail.value = email);
    ever(AuthService.userImageUrl, (String url) => userImageUrl.value = url.trim());

    ever(AuthService.userRole, (String role) {
      userRole.value = role.trim().isNotEmpty ? role.trim() : 'Customer';
    });

    ever(AuthService.isAuthenticated, (bool loggedIn) {
      if (!loggedIn) {
        _clearUserData();
      } else {
        _syncWithAuthService();
      }
    });
  }

  void confirmLogout() {
    Get.defaultDialog(
      title: "Are you sure you want to sign out?",
      middleText: "Signing out will temporarily hide all your personal data. To see these again, just log back into your account.",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,

      // ADD THIS FOR PADDING:
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
      titlePadding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0), // Optional: pad the title too

      onConfirm: () {
        Get.back();
        logout();
      },
    );
  }

  void logout() async {
    // 1. Capture the role before clearing any data state
    final bool userWasVendor = isVendor;

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

          // 2. Clear local storage authentication tokens globally
          // 2. Clear local storage authentication tokens globally
          // 2. Clear local storage authentication tokens globally
          await AuthService.to.logout();

          // 3. Reset the MainLayoutController active navigation flags
          if (Get.isRegistered<MainLayoutController>()) {
            final mainLayout = Get.find<MainLayoutController>();
            mainLayout.isLoggedIn.value = false;
            mainLayout.currentIndex.value = 0;
            mainLayout.userName.value = 'Guest';
          }

          // 4. DYNAMIC ROUTING FIRST
          if (userWasVendor) {
            Get.offAllNamed(Routes.SIGNIN);

            // 🟢 Clean dependency AFTER the view context has begun changing
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _cleanHomeDependency();
            });
          } else {
            // For a regular customer redirecting to home, do NOT hard delete it manually.
            // Let Get.offAllNamed drop and regenerate it naturally via MainLayout's bindings!
            Get.offAllNamed(Routes.MAIN_LAYOUT);
          }

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

// 🧼 Helper method to clear the memory footprint safely
  void _cleanHomeDependency() {
    try {
      if (Get.isRegistered<HomeController>()) {
        // 🟢 The force: true flag tells GetX to override the "permanent" lock and delete it anyway
        Get.delete<HomeController>(force: true);
      }
    } catch (e) {

    }
  }
  /// Helper logic to pull current data snapshot securely
  void _syncWithAuthService() {
    if (isAuthenticated) {
      userId.value = AuthService.userId.value; // 🟢 Directly assign int values
      userName.value = AuthService.userName.value;
      userEmail.value = AuthService.userEmail.value;
      userImageUrl.value = AuthService.userImageUrl.value.trim();
      userRole.value = AuthService.userRole.value.trim().isNotEmpty
          ? AuthService.userRole.value.trim()
          : 'Customer';
    } else {
      _clearUserData();
    }
  }

  /// Helper logic to purge state safely on logout or anonymous sessions
  void _clearUserData() {
    userId.value = 0; // 🟢 Reset to default integer
    userName.value = '';
    userEmail.value = '';
    userImageUrl.value = '';
    userRole.value = 'Customer';
  }

  void onEditProfilePressed() {
    print("Edit Profile Clicked for User ID: ${userId.value}");
  }
}