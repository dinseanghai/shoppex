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

  // =========================================================
  // OTP INPUTS
  // =========================================================

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  // =========================================================
  // STATES
  // =========================================================

  var isLoading = false.obs;

  var isResendSeconds = 59.obs;

  var canResend = false.obs;

  bool isVerifying = false;

  /// Ignore first autofill after resend
  bool ignoreNextAutoFill = false;

  Timer? _timer;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null &&
        Get.arguments is Map) {
      challengeId =
          Get.arguments['challenge_id'] ?? '';
    }

    startCountdown();

    // AUTO FOCUS FIRST OTP BOX
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty) {
        focusNodes.first.requestFocus();
      }
    });
  }

  // =========================================================
  // TIMER
  // =========================================================

  void startCountdown() {
    canResend.value = false;

    isResendSeconds.value = 59;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (isResendSeconds.value > 0) {
          isResendSeconds.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      },
    );
  }

  // =========================================================
  // OTP HELPERS
  // =========================================================

  String get completeOtp =>
      controllers.map((e) => e.text).join();

  bool get isOtpComplete =>
      completeOtp.length == 6;

  // =========================================================
  // OTP FIELD CHANGED
  // =========================================================

  void onOtpChanged({
    required int index,
    required String value,
  }) {
    if (isLoading.value) return;

    // --- FIX FOR OS AUTOFILL SPLITTING TENDENCIES ---
    // If someone autofills, a single box might suddenly get all 6 digits.
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        controllers[i].text = value[i];
      }
      FocusManager.instance.primaryFocus?.unfocus();
      verifyOtp();
      return;
    }

    // Move next field
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      }
    }
    // Backspace to previous field
    else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }

    // Last field interaction
    if (index == 5 && value.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();

      Future.delayed(
        const Duration(milliseconds: 100),
            () {
          final otp = controllers.map((e) => e.text).join();

          // Incomplete code string: do nothing
          if (otp.length != 6) return;

          // --- FIXED LOGIC ---
          // 'ignoreNextAutoFill' should ONLY block the immediate OS popup trigger.
          // If the value length is 1, the user typed this manually. Do NOT block it!
          if (ignoreNextAutoFill && value.length != 1) {
            ignoreNextAutoFill = false;
            return;
          }

          // Clean up flag now that typing/autofill resolved successfully
          ignoreNextAutoFill = false;

          verifyOtp();
        },
      );
    }
  }

  // =========================================================
  // VERIFY OTP
  // =========================================================

  Future<void> verifyOtp() async {
    if (isVerifying) return;

    if (!isOtpComplete) {
      Snackbars.verifyOtp();
      return;
    }

    try {
      isVerifying = true;

      isLoading.value = true;

      final req = OtpReg(
        challengeId: challengeId,
        otp: completeOtp,
      );

      final response =
      await _provider.verifyOtp(req);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuccessCheckAnimation(),

                const SizedBox(height: 16),

                const Text(
                  "Verification Successful!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Redirecting you to Signin...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        await Future.delayed(
          const Duration(seconds: 2),
        );

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.offAllNamed(
          Routes.SIGNIN,
          arguments: {
            'challenge_id': challengeId,
          },
        );

        return;
      }

      throw Exception(
        response.data?['message'] ??
            'Verification failed',
      );
    } catch (e) {
      // Clear fields
      for (var c in controllers) {
        c.clear();
      }

      // Focus first field
      focusNodes.first.requestFocus();

      final errorMessage =
      e.toString().toLowerCase();

      if (errorMessage.contains('expire')) {
        Snackbars.optexpired();
      } else {
        Snackbars.invalidotp();
      }
    } finally {
      isLoading.value = false;

      isVerifying = false;
    }
  }

  // =========================================================
  // RESEND OTP
  // =========================================================

  Future<void> resendOtpCode() async {
    if (!canResend.value) return;
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      // 1. Instantly clear boxes to reset widget states cleanly
      for (var c in controllers) {
        c.clear();
      }

      final req = ResendOtpReg(
        challengeId: challengeId,
      );

      final response = await _provider.resendOtp(req);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['challenge_id'] != null) {
          challengeId = response.data['challenge_id'].toString();
        }

        focusNodes.first.requestFocus();
        Snackbars.resendotp();
        startCountdown();

        // 2. Set autofill block strictly AFTER the UI clears down
        ignoreNextAutoFill = true;

      } else {
        throw Exception(
          response.data?['message'] ?? 'Failed to resend code',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }
  // =========================================================
  // CLEANUP
  // =========================================================

  @override
  void onClose() {
    _timer?.cancel();

    for (var c in controllers) {
      c.dispose();
    }

    for (var n in focusNodes) {
      n.dispose();
    }

    super.onClose();
  }
}