import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../../core/network/network_info.dart';


class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Connectivity(), fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()), fenix: true);
  }
}