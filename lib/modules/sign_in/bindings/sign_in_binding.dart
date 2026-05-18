import 'package:get/get.dart';
import '../../../core/network/network_info.dart';
import '../controllers/sign_in_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Provide the core Connectivity instance
    Get.lazyPut(() => Connectivity());

    // 2. Provide the NetworkInfo implementation
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));

    // 3. Inject the SignInController with its required NetworkInfo dependency
    Get.lazyPut<SignInController>(() => SignInController(networkInfo: Get.find()));
  }
}