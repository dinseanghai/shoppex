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
import '../../account/controllers/account_controller.dart';
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
        final data = response.data;

        // 1. Extract values exactly matching your API structure
        final String token = data['token'];
        final String name = data['user']['name'] ?? 'Hai';
        final String email = data['user']['email'] ?? 'dinseanghai95@gmail.com';

        // 🟢 FIX: Extract the role string out of the server's roles array list here!
        final List<dynamic> rolesList = data['user']['roles'] ?? [];
        final String role = rolesList.isNotEmpty ? rolesList[0].toString() : 'Customer';

        // 2. Save everything to disk storage all at once (including your newly defined role!)
        await SecureStorage.write(token);
        await SecureStorage.writeUserData(name: name, email: email, role: role);

        // 3. Authenticate active state instance variables
        AuthService.authToken.value = token;
        AuthService.isAuthenticated.value = true;

        // 4. Update the active MainLayoutController status fields
        if (Get.isRegistered<MainLayoutController>()) {
          final layoutController = Get.find<MainLayoutController>();
          layoutController.isLoggedIn.value = true;
          layoutController.userName.value = name;
        }

        // 5. Safely push real-time updates directly to your AccountController if active
        if (Get.isRegistered<AccountController>()) {
          final accountController = Get.find<AccountController>();
          accountController.userName.value = name;
          accountController.userEmail.value = email;
          accountController.userRole.value = role; // Updates your UI badge instantly
        }

        // 6. Clear stack tracking navigation histories and open main screen dashboard
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
