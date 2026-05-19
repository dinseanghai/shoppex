import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/validators.dart';
import '../../../data/local/secure_storage.dart';
import '../../../data/models/login_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/widgets/snackbars.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignInController extends GetxController with FormValidators {
  final _authprovider = Get.find<ApiClient>();
  final NetworkInfo networkInfo;

  // --- Form & Input Elements ---
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- Observables ---
  var isPasswordObscured = true.obs;
  final isOnline = true.obs;
  var isLoading = false.obs; // Added to manage your CustomButton loading state

  StreamSubscription? _networkSubscription;

  SignInController({required this.networkInfo});

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
    _listenToNetworkChanges();
  }

  /// Entry point triggered by the CustomButton in your SignInView
  // 1. CRITICAL: Add the 'async' keyword here
  void handleSignIn() {
    // 1. Triggers form validation
    if (formKey.currentState!.validate()) {

      // 2. Map form data safely
      final req = LoginReq(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // 3. Fire off the authentication API request
      // (No try-catch or isLoading management needed here anymore!)
      login(req);
    }
  }

  void login(LoginReq req) async {
    // Safety Guard: If it's already fetching, ignore subsequent taps
    if (isLoading.value) return;

    try {
      isLoading.value = true; // 1. Shows progress indicator on CustomButton

      final response = await _authprovider.login(req);

      if (response.statusCode == 200) {
        final token = response.data['token'];
        SecureStorage.write(token);
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
      isLoading.value = false; // 2. Hides progress indicator automatically on success or failure
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  // --- Network Connection Monitoring ---
  void _checkInitialStatus() async {
    final status = await networkInfo.isConnected;
    isOnline.value = status;
    _handleSnackbar(status);
  }

  void _listenToNetworkChanges() {
    _networkSubscription = networkInfo.onStatusChange.listen((status) {
      isOnline.value = status;
      _handleSnackbar(status);
    });
  }

  void _handleSnackbar(bool status) {
    if (!status) {
      if (Get.isSnackbarOpen) return;
      final failure = NetworkFailure();
      Snackbars.showNetworkError(failure.message);
    } else {
      if (Get.isSnackbarOpen) {
        Snackbars.closeAll();
        Snackbars.showSuccess();
      }
    }
  }

  @override
  void onClose() {
    // Clean up text editing streams to prevent context/memory leaks
    emailController.dispose();
    passwordController.dispose();

    // Clean up network background streams
    _networkSubscription?.cancel();
    super.onClose();
  }
}