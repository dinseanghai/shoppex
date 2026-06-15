import 'package:get/get.dart';
import '../controllers/base_home_controller.dart';
import '../controllers/customer_home_controller.dart';
import '../controllers/vender_home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BaseHomeController());

    Get.lazyPut(() => CustomerController());

    Get.lazyPut(() => VendorController());
  }
}