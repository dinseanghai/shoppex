import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import 'package:shoppex/data/models/request/forget_password.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/response/forget_password.dart';
import '../../../routes/app_pages.dart';

class ForgetPasswordController extends GetxController with FormValidators {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _authprovider = Get.find<ApiClient>();
  var isLoading = false.obs;

  void handleforgetpassword(FormState? formState) {
    if (formState != null && formState.validate()) {
      final req = ForgetPasswordReg(email: emailController.text.trim());
      forgetpassword(req);
    }
  }

  void forgetpassword(ForgetPasswordReg req) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final response = await _authprovider.forgetpassword(req);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ForgetPasswordResponse.fromJson(response.data);

        // ADJUSTMENT: Match against what your backend returns on fake emails.
        // If your server sends an empty string, literal null, or matching flag:
        if (apiResponse.challengeId == null ||
            apiResponse.challengeId!.isEmpty ||
            apiResponse.challengeId == "null") {

          Get.snackbar(
            'Error',
            'This email address is not registered with us.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
          return; // Block route execution context
        }

        // If a legitimate challenge ID exists, pass navigation forward
        Get.snackbar(
          'Success',
          apiResponse.message ?? 'A password reset OTP has been sent.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        Get.toNamed(
          Routes.HOME,
          arguments: {
            'challenge_id': apiResponse.challengeId,
            'email': req.email,
          },
        );
        return;
      }

      // Extract validation errors block (e.g. 422 Invalid Email Format)
      String errorMessage = 'An unknown error occurred';
      if (response.data != null) {
        if (response.data['errors'] != null && response.data['errors']['email'] != null) {
          errorMessage = response.data['errors']['email'][0];
        } else {
          errorMessage = response.data['message'] ?? errorMessage;
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

    } catch (e) {
      Get.snackbar(
        'Connection Error',
        'Failed to connect to the server.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}