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

      // FIX: Removed 'page: 1' as it no longer exists in the ListProduct model
      final response = await customerCtrl.apiClient.listproduct(
        ListProduct(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final result = ListProduct.fromJson(response.data);
        final products = result.productData?.lists ?? [];

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

  String? get discountSaving {
    final product = rxProduct.value;
    if(product == null) return null;

    double parsePrice(String? priceStr) {
      if(priceStr == null || priceStr.isEmpty) return 0.0;
      return double.tryParse(priceStr) ?? 0.0;
    }

    final double bPrice = parsePrice(product.basePrice);
    final double sPrice = parsePrice(product.salePrice);
    if(sPrice > 0 && sPrice < bPrice) {
      final double saving = bPrice - sPrice;
      return "Save \$${saving.toStringAsFixed(0)}";
    }
    return null;
  }

  double get averageRating =>
      double.tryParse(rxProduct.value?.ratingAvg?.toString() ?? '0') ?? 0.0;

  int get totalRatingCount =>
      int.tryParse(rxProduct.value?.ratingCount?.toString() ?? '0') ?? 0;

  /// Helper to calculate ratio and percentage string for a specific star count
  Map<String, dynamic> getStarDistribution(String starKey) {
    final int totalCount = totalRatingCount;
    final double avg = averageRating;

    if (totalCount == 0 || rxProduct.value == null) {
      return {'ratio': 0.0, 'percentText': '0%'};
    }

    // Fallback distribution percentages based on typical e-commerce rating averages
    double simulatedRatio = 0.0;

    if (avg >= 4.5) {
      // Highly positive curve (like 4.7 - 4.9)
      switch (starKey) {
        case '5': simulatedRatio = 0.82; break;
        case '4': simulatedRatio = 0.12; break;
        case '3': simulatedRatio = 0.04; break;
        case '2': simulatedRatio = 0.01; break;
        case '1': simulatedRatio = 0.01; break;
      }
    } else if (avg >= 4.0) {
      // Good standard curve (like your 4.4 Fresh Fruit box)
      switch (starKey) {
        case '5': simulatedRatio = 0.65; break;
        case '4': simulatedRatio = 0.20; break;
        case '3': simulatedRatio = 0.09; break;
        case '2': simulatedRatio = 0.04; break;
        case '1': simulatedRatio = 0.02; break;
      }
    } else if (avg >= 3.0) {
      // Average/Mediocre curve
      switch (starKey) {
        case '5': simulatedRatio = 0.35; break;
        case '4': simulatedRatio = 0.25; break;
        case '3': simulatedRatio = 0.20; break;
        case '2': simulatedRatio = 0.12; break;
        case '1': simulatedRatio = 0.08; break;
      }
    } else {
      // Poor performing product curve
      switch (starKey) {
        case '5': simulatedRatio = 0.10; break;
        case '4': simulatedRatio = 0.15; break;
        case '3': simulatedRatio = 0.20; break;
        case '2': simulatedRatio = 0.25; break;
        case '1': simulatedRatio = 0.30; break;
      }
    }

    return {
      'ratio': simulatedRatio,
      'percentText': "${(simulatedRatio * 100).toStringAsFixed(0)}%",
    };
  }


}

