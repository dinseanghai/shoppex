import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_textformfield.dart';
import '../../sign_in/widgets/google_signin.dart';
import '../controllers/sign_up_controller.dart';
import '../widgets/password_strength.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: CustomButton(
          buttontype: ButtonType.icon,
          icon: Icons.arrow_back,
          onPressed: () => Get.offNamed(Routes.SIGNIN),
        ),

        backgroundColor: AppColors.background,
        title: Text(
          'Create Account',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomFormField(
                    controller: controller.nameController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person_outline,
                    label: 'Full Name',
                    hint: 'Enter your Full Name',
                    showCheckmarkOnInput: true,
                  ),
                  AppSizes.gapH20,
                  CustomFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                    label: 'Email Address',
                    hint: 'Enter your Email Address',
                    showCheckmarkOnInput: true,
                  ),
                  AppSizes.gapH20,
                  CustomFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    label: 'Phone Number',
                    hint: 'Enter Your Phone Number',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneFormatter(), // Custom formatter from earlier response
                      LengthLimitingTextInputFormatter(12),
                    ],
                    prefix: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Text('🇰🇭', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text(
                                  '+855',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSizes.gapH20,
                  Obx(
                    () => CustomFormField(
                      prefixIcon: Icons.lock_outline,
                      hint: 'Enter your password',
                      isPassword: controller.isPasswordObscured.value,
                      keyboardType: TextInputType.visiblePassword,
                      controller: controller.passwordController,
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
                  AppSizes.gapH16,
                  Obx(
                    () => CustomFormField(
                      prefixIcon: Icons.lock_outline,
                      hint: 'Confirm password',
                      isPassword: controller.isPasswordObscured.value,
                      keyboardType: TextInputType.visiblePassword,
                      controller: controller.confirmPassController,
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
                  AppSizes.gapH20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns checkbox with the top line of text
                      children: [
                        // 1. Reactive Checkbox
                        Obx(
                              () => SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: controller.isAgreed.value,
                              onChanged: controller.toggleAgreement,
                              activeColor: Colors.blueAccent, // Matches the blue in your image
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Slightly rounded corners
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // Space between checkbox and text

                        // 2. Rich Text with Clickable Links
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87, // Main text color
                                height: 1.4,          // Line spacing matching the image
                              ),
                              children: [
                                const TextSpan(text: "I agree to the "),

                                // Terms of Service Link
                                TextSpan(
                                  text: "Terms of Service",
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle Terms of Service click
                                      print("Navigate to Terms of Service");
                                    },
                                ),

                                const TextSpan(text: " and "),

                                // Privacy Policy Link
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle Privacy Policy click
                                      print("Navigate to Privacy Policy");
                                    },
                                ),

                                const TextSpan(text: " of ShopeeX marketplace."),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSizes.gapH20,
                  CustomButton(
                    buttontype: ButtonType.elevated,
                      text: 'Continue',
                      isBold: true,
                      onPressed: (){}),
                  AppSizes.gapH20,
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR SIGN UP WITH',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                    ],
                  ),
                  AppSizes.gapH20,
                  GoogleSignInButton(onTap: () {}),
                  AppSizes.gapH48,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(Routes.SIGNIN); //  This replaces the screen and kills the duplicate key
                        },
                        child: const Text(
                          'Sign In',
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
