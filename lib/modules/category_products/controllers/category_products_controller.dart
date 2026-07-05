import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import 'package:shoppex/data/models/response/list_category.dart';
import 'package:shoppex/data/models/response/list_product.dart';

import '../../../data/models/response/product_favorite.dart';
import '../../../routes/app_pages.dart';

class CategoryProductsController extends GetxController {
  final ApiClient apiClient;
  CategoryProductsController({required this.apiClient});

  late CategoryData category;
  final productList = <ProductItem>[].obs;
  final isLoading = true.obs;
  final isMoreLoading = false.obs;

  int currentPage = 1;
  int lastPage = 1 ;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    category = Get.arguments as CategoryData;
    scrollController.addListener(_scrollListener);
    fetchProductsByCategory(page: 1);
  }

  Future<void> fetchProductsByCategory({int page =1}) async {

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await apiClient.listProductByCategory(
        categoryId: category.id!,
        page: page,
      );


      if (response.statusCode == 200 && response.data != null) {
        final result = ListProduct.fromJson(response.data);
        final newProducts = result.productData?.lists ?? [];

        currentPage = result.productData?.currentPage ?? page;
        lastPage = result.productData?.lastPage ?? 1;

        if (page == 1) {
          productList.assignAll(newProducts);
        } else {
          productList.addAll(newProducts);
        }

        productList.refresh();
      }
    } catch (e) {
      debugPrint('CategoryProductsController error: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;
    final isNearBottom = position.pixels >= position.maxScrollExtent - 200;

    if (isNearBottom && !isLoading.value && !isMoreLoading.value && currentPage < lastPage) {
      fetchProductsByCategory(page: currentPage + 1);
    }
  }
  void onProductClick(ProductItem product) {
    // Assuming 'Routes' is your constant class for route names
    Get.toNamed('${Routes.PRODUCT_DETAIL}/${product.id}', arguments: product);
  }

  Future<void> toggleFavorite(ProductItem product, {bool isUndo = false}) async {
    final bool oldStatus = product.isFavorite ?? false;

    // 1. Optimistic Update
    product.isFavorite = !oldStatus;
    productList.refresh();

    try {
      final response = await apiClient.favOnProduct(product.id!);
      final favoriteData = ProductFavorite.fromJson(response.data);

      if (response.statusCode != 200) throw Exception("Server Error");

      // 2. Only show snackbar if it was NOT an undo action
      if (!isUndo && favoriteData.isFavorite == false) {
        Get.showSnackbar(GetSnackBar(
          message: "Removed from Favourites",
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () {
              // Call the same function but mark it as an undo action
              toggleFavorite(product, isUndo: true);
              if (Get.isSnackbarOpen) Get.back();
            },
            child: const Text("Undo"),
          ),
        ));
      }
    } catch (e) {
      // 3. Revert state on failure
      product.isFavorite = oldStatus;
      productList.refresh();
      debugPrint("Favorite toggle failed: $e");
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}
