import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_size.dart';
import '../widgets/custom_button.dart';

class OtpLayout extends StatelessWidget {
  final String title;
  final String description;
  final String timerPrefixText;
  final String footerText;
  final String footerLinkText;

  // Accept the core configuration items dynamic or from the targeted controller
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final RxInt resendSeconds;
  final RxBool canResend;
  final RxBool isLoading;

  final Function(int index, String value) onOtpChanged;
  final VoidCallback onResendPressed;
  final VoidCallback onVerifyPressed;

  const OtpLayout({
    super.key,
    required this.title,
    required this.description,
    this.timerPrefixText = "Resend code in ",
    this.footerText = "By verifying, you agree to ShopeeX's ",
    this.footerLinkText = "Terms and Privacy Policy",
    required this.controllers,
    required this.focusNodes,
    required this.resendSeconds,
    required this.canResend,
    required this.isLoading,
    required this.onOtpChanged,
    required this.onResendPressed,
    required this.onVerifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'ShoppeX',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              AppSizes.gapH20,
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.phonelink_lock_rounded,
                    color: AppColors.buttonPrimary,
                    size: 32,
                  ),
                ),
              ),
              AppSizes.gapH24,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              AppSizes.gapH24,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Verification Code",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) => _buildOtpBox(index)),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Obx(
                            () => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(timerPrefixText, style: const TextStyle(color: Colors.grey)),
                                Text(
                                  "00:${resendSeconds.value.toString().padLeft(2, '0')}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the code? ",
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                GestureDetector(
                                  onTap: canResend.value ? onResendPressed : null,
                                  child: Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      color: canResend.value
                                          ? AppColors.buttonPrimary
                                          : Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Obx(
                    () => CustomButton(
                  buttontype: ButtonType.elevated,
                  iconAlignment: IconAlignment.start,
                  icon: Icons.verified_user_outlined,
                  text: 'Verify',
                  isBold: true,
                  isLoading: isLoading.value,
                  onPressed: isLoading.value ? null : onVerifyPressed,
                ),
              ),
              AppSizes.gapH48,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text.rich(
                  TextSpan(
                    text: footerText,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    children: [
                      TextSpan(
                        text: footerLinkText,
                        style: const TextStyle(
                          color: AppColors.buttonPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.buttonPrimary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) => onOtpChanged(index, value),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.buttonPrimary, width: 2),
          ),
        ),
      ),
    );
  }
}