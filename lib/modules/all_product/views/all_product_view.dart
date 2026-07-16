import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../home/widgets/customer/list_product.dart';
import '../controllers/all_product_controller.dart';

class AllProductView extends GetView<AllProductController> {
  const AllProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // We use NotificationListener to catch scroll events directly from the viewport
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Check if user is scrolling near the bottom (200px threshold)
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              // Trigger load more directly via controller check
              if (!controller.isMoreLoading.value && controller.currentPage < controller.lastPage) {
                controller.fetchProducts(page: controller.currentPage + 1);
              }
            }
            return true; // Stop notification bubbling
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Segment
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    _buildIconButton(Icons.arrow_back, () => Get.back()),
                    const SizedBox(width: 16),
                    const Text(
                      "ALL PRODUCTS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Product List Segment + Infinite Scroll Indicator
              Expanded(
                child: CustomScrollView(
                  // We still keep the controller here in case you need to programmatically scroll up
                  controller: controller.scrollController,
                  slivers: [
                    // Dynamic body: Show loader OR the product sliver list
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return const SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: ListProductView(),
                      );
                    }),

                    // Bottom Pagination Loader
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.isMoreLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: Colors.black, size: 20),
          onPressed: onPressed,
        ),
      ),
    );
  }
}