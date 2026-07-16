import 'package:flutter/material.dart';
import '../../home/controllers/customer_home_controller.dart';

class AllProductController extends CustomerController {
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    // Fetch initial data
    fetchProducts(page: 1);

    // Add pagination listener
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // 1. Ensure the controller is actually attached to a scroll view
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    // 2. Prevent triggers if the screen is not scrollable yet
    if (maxScroll <= 0) return;

    // Triggers when user is 200 pixels away from the bottom edge
    if (currentScroll >= maxScroll - 200) {
      // Access isMoreLoading with .value (RxBool),
      // but currentPage and lastPage directly as regular ints!
      if (!isMoreLoading.value && currentPage < lastPage) {
        fetchProducts(page: currentPage + 1);
      }
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}