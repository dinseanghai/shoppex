import 'package:get/get.dart';

import '../controllers/otp_resetpassword_controller.dart';

class OtpResetpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpResetpasswordController>(
      () => OtpResetpasswordController(),
    );
  }
}
