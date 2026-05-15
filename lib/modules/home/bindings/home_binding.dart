import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/network_info.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Connectivity());
    
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
    
    Get.lazyPut<HomeController>(() => HomeController(networkInfo: Get.find()));
  }
}
