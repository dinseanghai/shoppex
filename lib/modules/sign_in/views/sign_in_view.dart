import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/core/constants/app_string.dart';
import 'package:shoppex/core/theme/app_text_styles.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_textformfield.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController(networkInfo: Get.find()));

    // REMOVED: bool _obscurePassword = true; (We will use the controller state instead)

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
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
                  ),
                  AppSizes.gapH16,
                  Text('Password', style: AppTextStyles.displaySmall_Primary),
                  AppSizes.gapH8,

                  Obx(
                        () => CustomFormField(
                      prefixIcon: Icons.lock_outline,
                      hint: 'Enter your password',
                      isPassword: controller.isPasswordObscured.value,
                      keyboardType: TextInputType.visiblePassword,
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
                    child: IntrinsicWidth( // Forces the button to only take up its required text width
                      child: CustomButton(
                        buttontype: ButtonType.text,
                        text: 'Forgot Password?',
                        onPressed: () {},
                      ),
                    ),
                  ),
                  AppSizes.gapH24,
                  CustomButton(
                    buttontype: ButtonType.elevated,
                      iconAlignment: IconAlignment.start,
                      icon: Icons.login,
                      isBold: true,
                      text: 'Sign In', onPressed: (){})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
