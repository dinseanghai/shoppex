import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/otp_model.dart';
import '../../../data/models/resent_otp_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/snackbars.dart';
import '../widgets/check_animation.dart';

class OtpVerificationController extends GetxController {
  final _provider = Get.find<ApiClient>();

  String challengeId = '';

  // 6 individual FocusNodes and TextControllers for pin handling
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> controllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  var isLoading = false.obs;
  var isResendSeconds = 59.obs; // Controls the resend button cooldown
  var canResend = false.obs;
  Timer? _timer;

  // CRITICAL FIX: Guard flag to block auto-submit during programatic wipes
  bool isClearing = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      challengeId = Get.arguments['challenge_id'] ?? '';
    }
    startCountdown();
  }

  // Controls the "Resend Code" delay
  void startCountdown() {
    canResend.value = false;
    isResendSeconds.value = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isResendSeconds.value > 0) {
        isResendSeconds.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  // Safely clear input boxes and return focus to the first digit
  void clearOtpFieldsAndFocus() {
    isClearing = true; // Lock auto-verification triggers completely

    for (var controller in controllers) {
      controller.clear();
    }

    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus(); // Reset focus to cell #1
    }

    // A 150ms buffer completely covers all cascading text selection events safely
    Future.delayed(const Duration(milliseconds: 150), () {
      isClearing = false;
    });
  }

  // Concatenate all 6 individual box fields into one string
  String get completeOtp => controllers.map((c) => c.text).join();

  void verifyOtp() async {
    if (completeOtp.length < 6) {
      Snackbars.verifyOtp();
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final req = OtpReg(challengeId: challengeId, otp: completeOtp);
      final response = await _provider.verifyOtp(req);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuccessCheckAnimation(),
                const SizedBox(height: 16),
                const Text(
                  "Verification Successful!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Redirecting you to Signin...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back();

        // FIX: Pass the valid local challengeId instead of response.data['challenge_id']
        Get.offAllNamed(
          Routes.SIGNIN,
          arguments: {'challenge_id': challengeId},
        );
        return;
      }

      throw Exception(response.data?['message'] ?? 'Verification failed');

    } catch (e) {
      clearOtpFieldsAndFocus();

      final errorMessage = e.toString().toLowerCase();

      // Now this will only trigger if the backend explicitly returns an expiration message
      if (errorMessage.contains('expire')) {
        Get.snackbar(
          'Expired',
          'The OTP has expired. Please request a new code.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        Snackbars.invalidotp();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtpCode() async {
    if (!canResend.value || isLoading.value) return;

    try {
      isLoading.value = true;
      final req = ResendOtpReg(challengeId: challengeId);
      final response = await _provider.resendOtp(req);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['challenge_id'] != null) {
          challengeId = response.data['challenge_id'].toString();
        }

        clearOtpFieldsAndFocus();
        Get.snackbar('Success', 'A new verification code has been sent!');
        startCountdown();
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to resend code');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceFirst("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}