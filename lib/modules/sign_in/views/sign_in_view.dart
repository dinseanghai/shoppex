import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/core/constants/app_string.dart';
import 'package:shoppex/core/theme/app_text_styles.dart';
import 'package:shoppex/modules/sign_in/widgets/google_signin.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_textformfield.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key}); // Made const since we removed local stateful variables

  @override
  Widget build(BuildContext context) {
    // Injecting the controller
    final controller = Get.put(SignInController(networkInfo: Get.find()));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey, // Uses the controller's formKey
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        AppSizes.gapH16,
                        Text(
                          AppStrings.onboarding_1_title,
                          style: AppTextStyles.displayLarge_primary,
                        ),
                        Text(
                          AppStrings.onboarding_1_dec,
                          style: AppTextStyles.displaySmall_Secondary,
                        ),
                      ],
                    ),
                  ),
                  AppSizes.gapH48,
                  Text(
                    AppStrings.loginTitle,
                    style: AppTextStyles.displayLarge_Secondary,
                  ),
                  Text(
                    AppStrings.loginSubtitle,
                    style: AppTextStyles.displaySmall_Secondary,
                  ),
                  AppSizes.gapH32,
                  Text(
                    'Email Address',
                    style: AppTextStyles.displaySmall_Primary,
                  ),
                  AppSizes.gapH8,
                  CustomFormField(
                    prefixIcon: Icons.mail_outline_outlined,
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailController, // Correct
                    validator: controller.validateEmail,
                  ),
                  AppSizes.gapH16,
                  Text('Password', style: AppTextStyles.displaySmall_Primary),
                  AppSizes.gapH8,

                  // Listens to password visibility toggles
                  Obx(
                        () => CustomFormField(
                      prefixIcon: Icons.lock_outline,
                      hint: 'Enter your password',
                      isPassword: controller.isPasswordObscured.value,
                      keyboardType: TextInputType.visiblePassword,
                      controller: controller.passwordController,
                      validator: controller.validateRequired,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: IntrinsicWidth(
                      child: CustomButton(
                        buttontype: ButtonType.text,
                        text: 'Forgot Password?',
                        onPressed: () {},
                      ),
                    ),
                  ),
                  AppSizes.gapH24,

                  // Wrapped in Obx to listen to loading state changes
                  Obx(
                        () => CustomButton(
                      buttontype: ButtonType.elevated,
                      iconAlignment: IconAlignment.start,
                      icon: Icons.login,
                      isBold: true,
                      text: 'Sign In',
                      isLoading: controller.isLoading.value,
                      // FIX: Passing an empty function prevents double-taps without breaking the button's background style
                      onPressed: controller.isLoading.value
                          ? () {}
                          : () => controller.handleSignIn(),
                    ),
                  ),
                  AppSizes.gapH24,
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                    ],
                  ),
                  AppSizes.gapH24,
                  GoogleSignInButton(onTap: () {}),
                  AppSizes.gapH48,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      GestureDetector(
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
