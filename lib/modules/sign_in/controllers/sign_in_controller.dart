import '../../../core/network/api_client.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/request/login_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/snackbars.dart';
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

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;

        // 1. Extract values exactly matching your API structure
        final String name = data['user']?['name'] ?? 'Hai';

        // 2. Delegate all storage, caching, and state initialization to AuthService
        // 🟢 This automatically handles image_url, token, name, email, and roles safely!
        await AuthService.to.handleLoginSuccess(data);

        // 3. Update the active MainLayoutController status fields
        if (Get.isRegistered<MainLayoutController>()) {
          final layoutController = Get.find<MainLayoutController>();
          layoutController.userName.value = name;
          layoutController.isLoggedIn.value = true; // Recalculates bodyScreens & navItems reactively
        }

        // Note: You no longer manually need to check if AccountController is registered here!
        // Because AccountController's onInit() already listens to changes inside AuthService using `ever`.

        // 4. Clear stack tracking navigation histories and open main screen dashboard
        Get.offAllNamed(Routes.MAIN_LAYOUT);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showWelcomeAlert(
            userName: name,
            isGuest: false,
          );
        });

        return;
      }
      throw Exception(response.data['message'] ?? 'An unknown error occurred');
    } catch (e) {
      Snackbars.loginFailed();
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