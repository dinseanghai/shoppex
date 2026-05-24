import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/validators.dart';
import '../../../data/local/secure_storage.dart';
import '../../../data/models/login_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/network_service.dart';
import '../../../shared/widgets/snackbars.dart';
import 'dart:async';
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
    // 🔥 FORCE AN IMMEDIATE CONNECTION CHECK WHEN THIS CONTROLLER BEDS IN
    _checkNetworkOnEntrance();
  }

  void _checkNetworkOnEntrance() {
    // Wait until the current framework frame is completed and painted safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<NetworkService>()) {
        // Now it is completely safe to trigger UI state updates and rebuilds!
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

        Get.offAllNamed(Routes.HOME);

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