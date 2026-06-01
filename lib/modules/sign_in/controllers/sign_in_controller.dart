import '../../../core/network/api_client.dart';
import '../../../core/utils/validators.dart';
import '../../../data/local/secure_storage.dart';
import '../../../data/models/request/login_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/welcome_alert.dart';

class SignInController extends GetxController with FormValidators {
  final _authprovider = Get.find<ApiClient>();

  // --- Form & Input Elements ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- Observables ---
  var isPasswordObscured = true.obs;
  var isLoading = false.obs;

  SignInController();

  @override
  void onInit() {
    super.onInit();
    _checkNetworkOnEntrance();
  }

  void _checkNetworkOnEntrance() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<NetworkService>()) {
        Get.find<NetworkService>().activateNetworkChecking();
      }
    });
  }

  /// Entry point triggered by the CustomButton in your SignInView
  void handleSignIn(FormState? formState) {
    if (formState != null && formState.validate()) {
      final req = LoginReq(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      login(req);
    }
  }

  void login(LoginReq req) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await _authprovider.login(req);

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final name = response.data['user']['name'] ?? 'User';

        await SecureStorage.write(token);

        AuthService.isAuthenticated.value = true;
        AuthService.authToken.value = token;

        // 1. Force update the layout controller state if it exists
        if (Get.isRegistered<MainLayoutController>()) {
          final layoutController = Get.find<MainLayoutController>();
          layoutController.isLoggedIn.value = true;
          layoutController.userName.value = name;
        }

        // 2. Clear stack and route to MAIN_LAYOUT
        Get.offAllNamed(Routes.MAIN_LAYOUT);

        // ⭐ FIXED: Pass the local 'name' variable explicitly to the alert function
        // so it doesn't matter if the layout controller is still loading!
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showWelcomeAlert(
            userName: name, // Use local variable here
            isGuest: false,
          );
        });

        return;
      }
      throw Exception(response.data['message'] ?? 'An unknown error occurred');
    } catch (e) {
      // Modernizing the generic defaultDialog into a cleaner error snackbar setup
      Get.rawSnackbar(
        title: "Login Failed",
        message: e.toString().replaceFirst("Exception: ", ""),
        backgroundColor: Colors.redAccent.shade700,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
