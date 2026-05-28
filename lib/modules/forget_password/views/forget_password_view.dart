import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import 'package:shoppex/routes/app_pages.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_textformfield.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // REMOVED: final formKey = GlobalKey<FormState>(); -> Use controller.formKey instead!

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey, // FIX 1: Linked directly to controller key
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 72),
                        Text(
                          AppStrings.onboarding_1_title,
                          style: AppTextStyles.displayLarge_primary,
                        ),
                        AppSizes.gapH24,
                        const Text(
                          'Forgot Your Password?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        AppSizes.gapH8,
                        Text(
                          AppStrings.forgotpassword,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                        AppSizes.gapH48,
                        CustomFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                          label: 'Email Address',
                          hint: 'Enter your Email Address',
                          showCheckmarkOnInput: true,
                          validator: controller.validateEmail,
                        ),
                        AppSizes.gapH32,

                        // FIX 2: Wrap button with Obx to watch controller.isLoading updates
                        Obx(() => CustomButton(
                          buttontype: ButtonType.elevated,
                          text: 'Continue',
                          isBold: true,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.isLoading.value
                              ? null // Passing null automatically disables custom buttons cleanly
                              : () => controller.handleforgetpassword(controller.formKey.currentState),
                        )),

                        AppSizes.gapH12,
                        CustomButton(
                          buttontype: ButtonType.text,
                          text: 'Back to Sign In',
                          onPressed: () {
                            Get.offAllNamed(Routes.SIGNIN);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}