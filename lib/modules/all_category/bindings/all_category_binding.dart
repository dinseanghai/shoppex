import 'package:get/get.dart';

import '../controllers/all_category_controller.dart';

class AllCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllCategoryController>(
      () => AllCategoryController(),
    );
  }
}
