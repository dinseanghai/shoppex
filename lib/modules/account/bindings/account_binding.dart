import 'package:get/get.dart';

import '../controllers/customer_account_controller.dart';
import '../controllers/vender_account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    // Registered on standby. Will only instantiate when CustomerAccountMenu loads.
    Get.lazyPut<CustomerAccountController>(
          () => CustomerAccountController(),
    );

    // Registered on standby. Will only instantiate when VenderAccountMenu loads.
    Get.lazyPut<VenderAccountController>(
          () => VenderAccountController(),
    );
  }
}
