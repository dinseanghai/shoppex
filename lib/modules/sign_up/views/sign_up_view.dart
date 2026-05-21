import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/shared/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_textformfield.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: CustomButton(
          buttontype: ButtonType.icon,
          icon: Icons.arrow_back,
          onPressed: () => Get.back(),
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
                    keyboardType: TextInputType.phone,
                    label: 'Phone Number',
                    hint: 'Enter Your Phone Number',
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
