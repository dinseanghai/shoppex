import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';

import '../controllers/category_products_controller.dart';

class CategoryProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryProductsController>(
      () => CategoryProductsController(apiClient: Get.find<ApiClient>()),
    );
  }
}
