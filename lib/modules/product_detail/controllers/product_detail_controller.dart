import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/request/rating_product.dart';
import '../../../data/models/response/detail_product.dart';
import '../../../data/models/response/list_product.dart';
import '../../home/controllers/customer_home_controller.dart';

class ProductDetailController extends GetxController {
  var isExpanded = false.obs;

  // Switched completely from ProductItem to DetailProduct
  final Rxn<DetailProduct> rxProduct = Rxn<DetailProduct>();
  final RxBool isDetailsLoading = false.obs;

  // Rating submitting loading state
  final RxBool isRatingLoading = false.obs;

  // UI Interactive States
  final RxInt selectedColorIndex = 0.obs;
  final RxInt selectedSizeIndex = 0.obs;
  final RxInt quantity = 1.obs;

  // Image Slider UI States (User Slide Only)
  late PageController imagePageController;
  final RxInt currentImageIndex = 0.obs;

  // Synchronize directly with CustomerController reactive state
  RxBool get isFavorite {
    if (rxProduct.value == null) return false.obs;
    final customerCtrl = Get.find<CustomerController>();

    // Looks up using the list in CustomerController if needed
    final matchedProduct = customerCtrl.productList.firstWhereOrNull((p) => p.id == rxProduct.value!.id);
    return ((matchedProduct?.isFavorite ?? rxProduct.value!.isFavorite) == true).obs;
  }

  @override
  void onInit() {
    super.onInit();
    imagePageController = PageController(initialPage: 0);
    _initializeProduct();
  }

  @override
  void onClose() {
    imagePageController.dispose();
    super.onClose();
  }

  void _initializeProduct() {
    // 1. Initial lookup via Route memory handover parameters (Accepts DetailProduct now)
    if (Get.arguments != null && Get.arguments is DetailProduct) {
      rxProduct.value = Get.arguments as DetailProduct;
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

      final response = await customerCtrl.apiClient.productdetail(id);

      if (response.statusCode == 200 && response.data != null) {
        // Double-check if the JSON has a root "data" key mapping
        final Map<String, dynamic> productJson = response.data['data'];
        rxProduct.value = DetailProduct.fromJson(productJson);
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error fetching product details: $e\n$stackTrace");
    } finally {
      isDetailsLoading.value = false;
    }
  }

  /// SUBMIT PRODUCT RATING METHOD
  Future<RatingProduct?> submitProductRating({
    required int rating,
    required String comment,
  }) async {
    final product = rxProduct.value;
    if (product == null) {
      Get.snackbar("Error", "Product details not loaded yet.");
      return null;
    }

    try {
      isRatingLoading.value = true;
      final customerCtrl = Get.find<CustomerController>();

      // Fetch rating using your newly optimized endpoint layout
      final response = await customerCtrl.apiClient.ratingproduct(
        id: product.id.toString(),
        rating: rating,
        comment: comment,
      );

      if (response.statusCode == 200 && response.data != null) {
        final ratingResult = RatingProduct.fromJson(response.data);

        if (ratingResult.status == 'success') {
          // Update reactive model variables cleanly
          rxProduct.value = rxProduct.value?.copyWith(
            ratingAvg: ratingResult.ratingsAvg,
            ratingCount: ratingResult.ratingsCount,
            myRating: ratingResult.myRating,
          );

          // Force update Obx UI components
          rxProduct.refresh();
          return ratingResult;
        }
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint("❌ Error submitting rating inside Controller: $e\n$stackTrace");
      return null;
    } finally {
      isRatingLoading.value = false;
    }
  }

  void toggleFavorite() {
    if (rxProduct.value == null) return;

    // 1. Convert DetailProduct to a JSON Map
    final productJson = rxProduct.value!.toJson();

    // 2. Convert that Map directly into the ProductItem model your CustomerController expects
    final productItemFallback = ProductItem.fromJson(productJson);

    // 3. Pass the correctly typed object
    Get.find<CustomerController>().onProductFavoriteClick(productItemFallback);
  }

  void incrementQuantity() => quantity.value++;
  void decrementQuantity() { if (quantity.value > 1) quantity.value--; }

  double get totalPrice {
    final product = rxProduct.value;
    if (product == null) return 0.0;

    double parsePrice(String? priceStr) {
      if (priceStr == null || priceStr.isEmpty) return 0.0;
      return double.tryParse(priceStr) ?? 0.0;
    }

    final double sPrice = parsePrice(product.salePrice);
    final double bPrice = parsePrice(product.basePrice);

    final priceToUse = (sPrice > 0) ? sPrice : bPrice;
    return priceToUse * quantity.value.toDouble();
  }

  String? get discountSaving {
    final product = rxProduct.value;
    if (product == null) return null;

    double parsePrice(String? priceStr) {
      if (priceStr == null || priceStr.isEmpty) return 0.0;
      return double.tryParse(priceStr) ?? 0.0;
    }

    final double bPrice = parsePrice(product.basePrice);
    final double sPrice = parsePrice(product.salePrice);

    if (sPrice > 0 && sPrice < bPrice) {
      final double saving = bPrice - sPrice;
      return "Save \$${saving.toStringAsFixed(0)}";
    }
    return null;
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  double get averageRating =>
      double.tryParse(rxProduct.value?.ratingAvg?.toString() ?? '0') ?? 0.0;

  int get totalRatingCount =>
      int.tryParse(rxProduct.value?.ratingCount?.toString() ?? '0') ?? 0;

  Map<String, dynamic> getStarDistribution(String starKey) {
    final int totalCount = totalRatingCount;
    final double avg = averageRating;

    if (totalCount == 0 || rxProduct.value == null) {
      return {'ratio': 0.0, 'percentText': '0%'};
    }

    double simulatedRatio = 0.0;

    if (avg >= 4.5) {
      switch (starKey) {
        case '5': simulatedRatio = 0.82; break;
        case '4': simulatedRatio = 0.12; break;
        case '3': simulatedRatio = 0.04; break;
        case '2': simulatedRatio = 0.01; break;
        case '1': simulatedRatio = 0.01; break;
      }
    } else if (avg >= 4.0) {
      switch (starKey) {
        case '5': simulatedRatio = 0.65; break;
        case '4': simulatedRatio = 0.20; break;
        case '3': simulatedRatio = 0.09; break;
        case '2': simulatedRatio = 0.04; break;
        case '1': simulatedRatio = 0.02; break;
      }
    } else if (avg >= 3.0) {
      switch (starKey) {
        case '5': simulatedRatio = 0.35; break;
        case '4': simulatedRatio = 0.25; break;
        case '3': simulatedRatio = 0.20; break;
        case '2': simulatedRatio = 0.12; break;
        case '1': simulatedRatio = 0.08; break;
      }
    } else {
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

