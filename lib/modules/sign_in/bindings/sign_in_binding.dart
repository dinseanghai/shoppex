import 'package:get/get.dart';
import '../../../core/network/network_info.dart';
import '../controllers/sign_in_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}