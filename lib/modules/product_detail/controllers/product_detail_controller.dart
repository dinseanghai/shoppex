import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/response/list_product.dart';
import '../../home/controllers/customer_home_controller.dart';

class ProductDetailController extends GetxController {
  final Rxn<ProductItem> rxProduct = Rxn<ProductItem>();
  final RxBool isDetailsLoading = false.obs;

  // UI Interactive States
  final RxInt selectedColorIndex = 0.obs;
  final RxInt selectedSizeIndex = 0.obs;
  final RxInt quantity = 1.obs;

  // Synchronize directly with CustomerController reactive state
  RxBool get isFavorite {
    if (rxProduct.value == null) return false.obs;
    final customerCtrl = Get.find<CustomerController>();
    final matchedProduct = customerCtrl.productList.firstWhereOrNull((p) => p.id == rxProduct.value!.id);
    return ((matchedProduct?.isFavorite ?? rxProduct.value!.isFavorite) == true).obs;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeProduct();
  }

  void _initializeProduct() {
    // 1. Initial lookup via Route memory handover parameters
    if (Get.arguments != null && Get.arguments is ProductItem) {
      rxProduct.value = Get.arguments as ProductItem;
    }

    // 2. Fallback network request execution using path ID parameter string
    final String? productIdStr = Get.parameters['id'];
    if (productIdStr != null && rxProduct.value == null) {
      fetchProductDetails(productIdStr);
    }
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isDetailsLoading.value = true;
      final customerCtrl = Get.find<CustomerController>();

      // Utilize your existing CustomerController apiClient architecture
      final response = await customerCtrl.apiClient.listproduct(
        ListProduct(page: 1), // Pass extra structures if your endpoints demand an explicit id
      );

      if (response.statusCode == 200 && response.data != null) {
        final result = ListProduct.fromJson(response.data);
        final products = result.productData?.lists ?? [];

        // Locate matching server structural records
        final matchedItem = products.firstWhereOrNull((element) => element.id.toString() == id);
        if (matchedItem != null) {
          rxProduct.value = matchedItem;
        }
      }
    } catch (e) {
      debugPrint('fetchProductDetails error: $e');
    } finally {
      isDetailsLoading.value = false;
    }
  }

  void toggleFavorite() {
    if (rxProduct.value == null) return;
    // Proxies the logic to your existing CustomerController matching fallback items
    Get.find<CustomerController>().onProductFavoriteClick(rxProduct.value!);
  }

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() { if (quantity.value > 1) quantity.value--; }

  double get totalPrice {
    final product = rxProduct.value;
    if (product == null) return 0.0;

    // Helper to safely parse String? to double
    double parsePrice(String? priceStr) {
      if (priceStr == null || priceStr.isEmpty) return 0.0;
      return double.tryParse(priceStr) ?? 0.0;
    }

    final double sPrice = parsePrice(product.salePrice);
    final double bPrice = parsePrice(product.basePrice);

    // Use salePrice if it's valid, otherwise fallback to basePrice
    final priceToUse = (sPrice > 0) ? sPrice : bPrice;

    return priceToUse * quantity.value.toDouble();
  }

}

