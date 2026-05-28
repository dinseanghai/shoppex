import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../controllers/otp_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

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
              // Top Icon Badge
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
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              AppSizes.gapH24,

              // --- WHITE VERIFICATION CARD ---
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Enter the 6-digit code below",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // OTP Input Row (6 Boxes)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => _buildOtpBox(index),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Timer & Resend Section
                    Center(
                      child: Obx(
                        () => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Resend code in ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  "00:${controller.isResendSeconds.value.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the code? ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.canResend.value
                                      ? () => controller.resendOtpCode()
                                      : null,
                                  child: Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      color: controller.canResend.value
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

              // --- VERIFY BUTTON ---
              Obx(
                () => CustomButton(
                  buttontype: ButtonType.elevated,
                  iconAlignment: IconAlignment.start,
                  icon: Icons.verified_user_outlined,
                  text: 'Verify',
                  isBold: true,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.verifyOtp(),
                ),
              ),

              AppSizes.gapH48,
              // Footer Links
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text.rich(
                  TextSpan(
                    text: "By verifying, you agree to ShopeeX's ",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Terms and Privacy Policy",
                        style: TextStyle(
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
        controller: controller.controllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        // Remove maxLength: 1 here so it can accept 6 digits during paste/autofill
        autofillHints: const [AutofillHints.oneTimeCode],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.buttonPrimary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          // Remove LengthLimitingTextInputFormatter(1) so it doesn't clip multi-digit inputs
        ],
        onChanged: (value) {
          controller.onOtpChanged(index: index, value: value);
        },
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.buttonPrimary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
