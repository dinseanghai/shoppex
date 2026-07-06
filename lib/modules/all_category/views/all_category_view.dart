import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';

import '../../home/controllers/customer_home_controller.dart';
import '../controllers/all_category_controller.dart';

class AllCategoryView extends GetView<AllCategoryController> {
  const AllCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row with your custom button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _buildIconButton(Icons.arrow_back, () => Get.back()),
                  const SizedBox(width: 15),
                  const Text("Shop by Category", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Existing Body Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SIDEBAR
                  Container(
                    width: 120,
                    color: Colors.grey.shade100,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Moving the ListView inside Obx ensures it rebuilds
                      // whenever controller.selectedCategoryName changes!
                      return ListView.builder(
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          final isSelected = controller.selectedCategoryName.value.trim() == (category.name ?? '').trim();

                          return InkWell(
                            onTap: () => controller.selectCategory(category.name ?? ''),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.transparent,
                                border: isSelected
                                    ? const Border(left: BorderSide(color: Color(0xFF3B59F6), width: 3))
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  category.name ?? '',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? const Color(0xFF3B59F6) : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  // GRID CONTENT
                  Expanded(
                    child: Obx(() {
                      if (controller.selectedCategoryName.value.isEmpty) {
                        return const Center(child: Text("Select a category"));
                      }
                      final items = controller.subCategoryMap[controller.selectedCategoryName.value] ?? [];
                      if (items.isEmpty) {
                        return const Center(child: Text("No sub-categories found"));
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.category, color: Colors.blue, size: 35),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(items[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildIconButton(IconData icon, VoidCallback onPressed, {Color color = Colors.black}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
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
