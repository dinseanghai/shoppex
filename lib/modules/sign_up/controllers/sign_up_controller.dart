import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/request/register_model.dart';
import '../../../routes/app_pages.dart';

class SignUpController extends GetxController with FormValidators {
  final formKey = GlobalKey<FormState>();

  final _authprovider = Get.find<ApiClient>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  var isNameValid = false.obs;
  var isAgreed = false.obs;
  var isLoading = false.obs;  

  var isPasswordObscured = true.obs;
  var passwordStrength = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    passwordController.addListener(() {
      passwordStrength.value = CheckPasswordStrength.calculateStrength(
        passwordController.text,
      );
    });
    nameController.addListener(() {
      if (nameController.text.isNotEmpty) {
        isNameValid.value = true;
      } else {
        isNameValid.value = false;
      }
    });

    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        isNameValid.value = true;
      } else {
        isNameValid.value = false;
      }
    });
  }

  void handleSignUp(FormState? formState) {
    if (formState != null && formState.validate()) {
      final req = RegisterReq(
        name: nameController.text,
        email: emailController.text.trim(),
        phone: phoneController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPassController.text,
      );
      register(req);
    }
  }

  void register(RegisterReq req) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final response = await _authprovider.register(req);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 1. Show the success snackbar (default duration is ~3 seconds)
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFFE8F5E9), // Light pleasant green background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0), // Matching your rounded corner style
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            content: Column(
              mainAxisSize: MainAxisSize.min, // Keeps the dialog tightly fit in the middle
              children: [
                // Optional: You can add a success icon here if you want
                Text(
                  "Success",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Account Created successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false, // Prevents user from dismissing it manually during the 3-second delay
        );

        // 2. Wait for 3 seconds so the user can actually see the snackbar
        await Future.delayed(const Duration(seconds: 2));


        Get.offAllNamed(Routes.OTP,arguments: {
          'challenge_id': response.data['challenge_id'], // Ensure this key matches exactly!
        },);

      } else {
        // Fixed: Move the throw inside an 'else' block so it doesn't interrupt success
        throw Exception(response.data['message'] ?? 'An unknown error occurred');
      }
    } catch (e) {
      // Fixed: Changed title from "Register Success" to "Registration Failed"
      Get.defaultDialog(
        title: "Registration Failed",
        middleText: e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleAgreement(bool? value) {
    isAgreed.value = value ?? false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
