import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../home/widgets/customer/list_store.dart';
import '../controllers/all_store_controller.dart';

class AllStoresView extends GetView<AllStoreController> {
  const AllStoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          // Initial full-page loading indicator
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
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
                      "ALL STORES",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal Circle Categories Slider
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: controller.storeList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final store = controller.storeList[index];

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            Routes.STORE_DETAIL,
                            arguments: store,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                              store.logo != null && store.logo!.isNotEmpty
                                  ? NetworkImage(store.logo!)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 60,
                          child: Text(
                            store.name ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 3-Size Structural Staggered Mosaic Grid with Infinite Scroll
              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController, // ATTACHED SCROLL CONTROLLER HERE
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: List.generate(controller.storeList.length, (index) {
                          final store = controller.storeList[index];

                          // Balanced 6-item loop sequence
                          final int patternIndex = index % 6;

                          // Items at index 0 and 3 stretch full-width
                          final bool isFullWidth = (patternIndex == 0 || patternIndex == 3);

                          int cardSizeType = 2; // Default Type 2 (Standard Column Split)

                          if (patternIndex == 0) {
                            cardSizeType = 1; // Type 1: Widescreen Horizontal Card
                          } else if (patternIndex == 3) {
                            cardSizeType = 3; // Type 3: Full-Width Tall Banner Hero Card
                          }

                          return StaggeredGridTile.fit(
                            crossAxisCellCount: isFullWidth ? 2 : 1,
                            child: StoreCard(
                              store: store,
                              width: double.infinity,
                              sizeType: cardSizeType,
                            ),
                          );
                        }),
                      ),

                      // Bottom Infinite Loader Indicator
                      Obx(() {
                        if (controller.isLoadingMore.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 24); // Bottom buffer spacing when done loading
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
