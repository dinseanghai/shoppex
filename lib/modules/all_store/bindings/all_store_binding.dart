import 'package:get/get.dart';

import '../controllers/all_store_controller.dart';

class AllStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllStoreController>(
      () => AllStoreController(),
    );
  }
}
