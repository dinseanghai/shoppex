import 'package:flutter/material.dart';
import '../../home/controllers/customer_home_controller.dart';

class AllProductController extends CustomerController {
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data
    fetchProducts(page: 1);

    // Add pagination listener
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isMoreLoading.value && currentPage < lastPage) {
        fetchProducts(page: currentPage + 1);
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
