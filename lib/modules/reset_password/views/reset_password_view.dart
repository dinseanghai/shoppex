import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shoppex/core/constants/app_assets.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import 'package:shoppex/shared/widgets/custom_textformfield.dart';

import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/password_strength.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 72),
                    Text(
                      AppStrings.onboarding_1_title,
                      style: AppTextStyles.displayLarge_primary,
                    ),
                    AppSizes.gapH16,
                    const Text(
                      'Forgot Your Password?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      AppAssets.reset_password,
                      height: 180, // Adjust size as needed
                    ),
                    AppSizes.gapH8,
                    Text(
                      AppStrings.resetpassword,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    AppSizes.gapH24,
                    Obx(
                      () => CustomFormField(
                        label: 'New Password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outline,
                        hint: 'Enter your password',
                        isPassword: controller.isPasswordObscured.value,
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordObscured.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    AppSizes.gapH12,
                    Obx(
                          () => PasswordStrengthIndicator(
                        strength: controller.passwordStrength.value,
                      ),
                    ),
                    AppSizes.gapH24,
                    Obx(
                          () => CustomFormField(
                        label: 'Confirm Password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outline,
                        hint: 'Confirm your Password',
                        isPassword: controller.isPasswordObscured.value,
                        controller: controller.confirmPasswordController,
                        validator: (val) => controller.validateConfirmPassword(
                          val,
                          controller.passwordController.text,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordObscured.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    AppSizes.gapH48,
                    Obx(
                          () => CustomButton(
                        buttontype: ButtonType.elevated,
                        text: 'Reset Password',
                        isBold: true,
                        isLoading: controller.isLoading.value,
                        // Passing null completely disables the button UI-wise while loading
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.handleForgotPassword(controller.formKey.currentState),
                      ),
                    ),
                    AppSizes.gapH12,
                    CustomButton(
                        buttontype: ButtonType.text,
                        text: 'Back to Sign In',
                        onPressed: () {
                          Get.offAllNamed(Routes.SIGNIN);
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
