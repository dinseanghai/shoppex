import 'package:get/get.dart';
import '../controllers/base_home_controller.dart';
import '../controllers/customer_home_controller.dart';
import '../controllers/vender_home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Make these permanent so they survive route changes
    Get.put(BaseHomeController(), permanent: true);
    Get.put(CustomerController(), permanent: true);
    Get.put(VenderController(), permanent: true);
  }
}