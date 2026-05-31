import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import 'package:shoppex/data/models/request/forget_password.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/response/forget_password.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/snackbars.dart';

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

        Snackbars.resetotp();

        Get.offAllNamed(
          Routes.OTP_RESETPASSWORD,
          arguments: {
            'challenge_id': apiResponse.challengeId,
            'email': req.email,
          },
        );
        return;
      }

    } catch (e) {
      // Empty because your connectivity stream manages connection issues
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