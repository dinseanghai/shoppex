import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/request/reset_password.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/icon_animation.dart';

class ResetPasswordController extends GetxController with FormValidators {
  final formKey = GlobalKey<FormState>();
  final _authprovider = Get.find<ApiClient>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordObscured = true.obs;
  var passwordStrength = 0.obs;
  var isLoading = false.obs;
  late final String challengeId;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    challengeId = Get.arguments?['challenge_id'] ?? 'default_challenge_id';

    passwordController.addListener(() {
      passwordStrength.value = CheckPasswordStrength.calculateStrength(
        passwordController.text,
      );
    });
  }

  void handleForgotPassword(FormState? formState) {
    if (formState != null && formState.validate()) {
      final req = ResetPasswordReg(
        challengeId: challengeId,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
      resetpassword(req);
    }
  }

  void resetpassword(ResetPasswordReg req) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final response = await _authprovider.resetpassword(req);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconAnimation(icon: Icons.lock_reset_outlined, color: Colors.blueAccent),

                const SizedBox(height: 16),

                const Text(
                  "Password Reset",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 8),

                Text(
                  "Your Password has been Reset Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(Routes.SIGNIN);
      } else {

        throw Exception(
          response.data['message'] ?? 'An unknown error occurred',
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Registration Failed",
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
    // TODO: implement onClose
    super.onClose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
