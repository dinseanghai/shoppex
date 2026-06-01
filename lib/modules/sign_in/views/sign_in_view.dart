import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/core/constants/app_string.dart';
import 'package:shoppex/core/theme/app_text_styles.dart';
import 'package:shoppex/modules/sign_in/widgets/google_signin.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_textformfield.dart';
import '../controllers/sign_in_controller.dart';
import '../widgets/welcome_alert.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // CLEANED: Instantiated via find() assuming it is initialized in your routing binding.
    // If you are not using bindings for this specific route, use: Get.put(SignInController());
    final controller = Get.find<SignInController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
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
                    controller: controller.emailController,
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
                        onPressed: () {
                          Get.offAllNamed(Routes.FORGET_PASSWORD);
                        },
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
                      onPressed: controller.isLoading.value
                          ? () {}
                          : () => controller.handleSignIn(formKey.currentState),
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
                        onTap: () {
                          Get.offNamed(Routes.SIGN_UP);
                        },
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
                  AppSizes.gapH8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Continue as ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      GestureDetector(
                        // ⭐ FIXED: Added routing delay to prevent GetX execution memory wipe
                        onTap: () {
                          Get.offAllNamed(Routes.MAIN_LAYOUT);

                          Future.delayed(const Duration(milliseconds: 250), () {
                            showWelcomeAlert(
                              userName: "Guest",
                              isGuest: true,
                            );
                          });
                        },
                        child: const Text(
                          'Guest Mode',
                          style: TextStyle(
                            color: Color(0xFF3B59F6),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}