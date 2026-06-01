import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/loading_widget.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var deliveryLocation = 'Toul Kork, Phnom Penh'.obs;

  void changeLocation() {
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
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back(); // Dismiss the alert dialog frame
        logout();   // Execute the overlay loading sign-out sequence
      },
    );
  }

  void logout() async {
    // ⭐ THE FIX: Mounts a persistent global loading overlay over the view layer tree
    Get.showOverlay(
      loadingWidget: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          // Using your premium custom LoadingWidget here!
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
          // Add a short artificial delay (e.g. 800ms) so the custom spin animation
          // can be fully appreciated by the user before transitioning out.
          await Future.delayed(const Duration(milliseconds: 800));

          // 1. Clear local storage authentication tokens globally
          await AuthService.to.logout();

          // 2. Reset the MainLayoutController active navigation flags
          if (Get.isRegistered<MainLayoutController>()) {
            final mainLayout = Get.find<MainLayoutController>();
            mainLayout.isLoggedIn.value = false;
            mainLayout.currentIndex.value = 0; // Return tab back to home dashboard
          }

          // 3. Wipe current tree context memory and send them to login screen
          Get.offAllNamed(Routes.SIGNIN);

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