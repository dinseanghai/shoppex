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
        Get.find<NetworkService>().enableBlockerAndCheck();
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

        // ⭐ CRITICAL CHANGE FOR GUEST TO USER TRANSITION:
        // Update the MainLayoutController state if it's currently in memory
        if (Get.isRegistered<MainLayoutController>()) {
          Get.find<MainLayoutController>().isLoggedIn.value = true;
        }

        // Route to MAIN_LAYOUT displaying the layout shell with the bottom bar active
        Get.offAllNamed(Routes.MAIN_LAYOUT);

        return;
      }
      throw Exception(response.data['message'] ?? 'An unknown error occurred');
    } catch (e) {
      Get.defaultDialog(
        title: "Login Failed",
        middleText: e.toString().replaceFirst("Exception: ", ""),
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