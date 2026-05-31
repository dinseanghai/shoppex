import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/layouts/otp_layout.dart';
import '../controllers/otp_resetpassword_controller.dart';


class OtpResetpasswordView extends GetView<OtpResetpasswordController> {
  const OtpResetpasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return OtpLayout(
      title: 'Enter Verification Code',
      description: 'Enter the 6-digit code below',
      controllers: controller.controllers,
      focusNodes: controller.focusNodes,
      resendSeconds: controller.isResendSeconds,
      canResend: controller.canResend,
      isLoading: controller.isLoading,
      onOtpChanged: (index, value) =>
          controller.onOtpChanged(index: index, value: value),
      onResendPressed: () => controller.resendOtpCode(),
      onVerifyPressed: () => controller.verifyOtp(),
    );
  }
}
