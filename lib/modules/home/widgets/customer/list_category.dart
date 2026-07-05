import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../category_products/bindings/category_products_binding.dart';
import '../../../category_products/views/category_products_view.dart';
import '../../controllers/customer_home_controller.dart';



class CategoryHorizontalList extends GetView<CustomerController> {
  const CategoryHorizontalList({super.key});

  static const double _height = 100;
  static const double _itemWidth = 80;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ======================================================
      // LOADING STATE
      // ======================================================
      if (controller.isLoading.value &&
          controller.categories.isEmpty) {
        return const SizedBox(
          height: _height,
          child: Center(
            child: LoadingWidget(),
          ),
        );
      }

      // ======================================================
      // EMPTY STATE
      // ======================================================
      if (controller.categories.isEmpty) {
        return const SizedBox(
          height: _height,
          child: Center(
            child: Text('No categories found'),
          ),
        );
      }

      // ======================================================
      // LIST VIEW
      // ======================================================
      return SizedBox(
        height: _height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];

            return GestureDetector(
              onTap: () {
                Get.to(
                      () => const CategoryProductsView(),
                  binding: CategoryProductsBinding(),
                  arguments: category,
                )?.then((hasChanged) {
                  if (hasChanged == true) {
                    // Now this matches the method definition with 0 arguments!
                    controller.refreshProductStatus();
                  }
                });
              },
              child: SizedBox(
                width: _itemWidth,
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(category.name ?? ''),
                        color: const Color(0xFF3B59F6),
                        size: 24,
                      ),
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      height: 34,
                      child: Text(
                        category.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ======================================================
  // CATEGORY ICON MAPPING
  // ======================================================
  IconData _getCategoryIcon(String name) {
    final value = name.toLowerCase().trim();

    switch (value) {
      case 'electronic':
      case 'electronics':
        return Icons.smartphone_rounded;

      case 'fashion':
        return Icons.checkroom;

      case 'home & living':
        return Icons.chair_outlined;

      case 'beauty & personal care':
        return Icons.auto_awesome;

      case 'sports & outdoors':
        return Icons.sports_baseball_outlined;

      case 'books & stationery':
        return Icons.book_outlined;

      case 'toys, kids & baby':
        return Icons.toys_outlined;

      case 'automotive':
        return Icons.car_repair;

      default:
        return Icons.category_rounded;
    }
  }
}