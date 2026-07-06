import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';

import '../../home/widgets/customer/list_store.dart';
import '../controllers/all_store_controller.dart';

class AllStoresView extends GetView<AllStoreController> {
  const AllStoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ALL STORES"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // Using your custom button as the leading icon
        leadingWidth: 70,
        leading: Center(
          child: _buildIconButton(Icons.arrow_back, () => Get.back()),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Header Section
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.storeList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final store = controller.storeList[index];
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blueAccent, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: store.logo != null && store.logo!.isNotEmpty
                              ? NetworkImage(store.logo!)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          store.name ?? 'Store',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Staggered Grid Section
            // Expanded(
            //   child: MasonryGridView.count(
            //     padding: const EdgeInsets.all(12),
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 12,
            //     crossAxisSpacing: 12,
            //     itemCount: controller.storeList.length,
            //     itemBuilder: (context, index) {
            //       // Ensure you are calling 'StoreCard', not 'ListStoreView' here
            //       return StoreCard(
            //         store: controller.storeList[index],
            //         width: double.infinity,
            //       );
            //     },
            //   ),
            // ),
          ],
        );
      }),
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
