import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/utils/formatters.dart';

class SignUpController extends GetxController {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  var isNameValid = false.obs;
  var isAgreed = false.obs;

  var isPasswordObscured = true.obs;
  var passwordStrength = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    passwordController.addListener((){
      passwordStrength.value = CheckPasswordStrength.calculateStrength(passwordController.text);
    });
    nameController.addListener((){
      if(nameController.text.isNotEmpty) {
        isNameValid.value =true;
      } else {
        isNameValid.value = false;
      }
    });

    emailController.addListener((){
      if(emailController.text.isNotEmpty) {
        isNameValid.value =true;
      } else {
        isNameValid.value = false;
      }
    });
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
    super.onClose();
  }
}
