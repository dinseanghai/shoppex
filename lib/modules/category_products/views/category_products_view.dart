import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';

import '../../home/widgets/customer/list_product.dart';
import '../controllers/category_products_controller.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildIconButton(Icons.arrow_back, () => Get.back()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      controller.category.name ?? 'Category Products',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.productList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!controller.isLoading.value &&
                  controller.productList.isEmpty) {
                return const Center(
                  child: Text('No products found in this category'),
                );
              }
              return GridView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount:
                    controller.productList.length +
                    (controller.isMoreLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.productList.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ProductCardItem(
                    product: controller.productList[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Your Helper Widget
  Widget _buildIconButton(
    IconData icon,
    VoidCallback onPressed, {
    Color color = Colors.black,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.8),
        radius: 20,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: 20),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
