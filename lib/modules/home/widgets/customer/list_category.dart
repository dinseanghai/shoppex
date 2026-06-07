import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/controllers/home_controller.dart';
import '../../../../shared/widgets/loading_widget.dart';

class CategoryHorizontalList extends GetView<HomeController> {
  const CategoryHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. Changed from 125 to 100 to pull the next section up completely!
      const double elementHeight = 100.0;

      if (controller.isLoading.value) {
        return const SizedBox(
          height: elementHeight,
          child: Center(child: LoadingWidget()),
        );
      }

      if (controller.categories.isEmpty) {
        return const SizedBox(
          height: elementHeight,
          child: Center(child: Text("No categories found")),
        );
      }

      return SizedBox(
        height: elementHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return GestureDetector(
              onTap: () {
                debugPrint("Selected category: ${category.name}");
              },
              child: SizedBox(
                width: 80, // Keeping a crisp card element layout width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Circular Icon Container ---
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(category.name ?? ''),
                        color: const Color(0xFF3B59F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // --- Category Label Text ---
                    // 2. Bound text footprint neatly inside 34px bounds
                    SizedBox(
                      height: 34,
                      child: Text(
                        category.name ?? '',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase().trim()) {
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