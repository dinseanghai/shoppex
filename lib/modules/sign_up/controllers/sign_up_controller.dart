import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var isNameValid = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
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
  @override
  void onClose() {
    // TODO: implement onClose
    nameController.dispose();
    super.onClose();
  }
}
