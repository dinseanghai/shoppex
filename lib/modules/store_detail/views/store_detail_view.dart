import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import '../controllers/store_detail_controller.dart';
import '../widgets/store_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoreDetailView extends GetView<StoreDetailController> {
  const StoreDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    const double bannerHeight = 230;
    const double headerHeight = bannerHeight + 35;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            // 1. Core ScrollView Layout
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: headerHeight + statusBarHeight + 20),
                      const StoreProfile(),
                      const SizedBox(height: 24),

                      // Reactive dynamic inventory products conditional grid block
                      Obx(() {
                        final store = controller.rxStore.value;
                        final products = store?.products;

                        if (products == null || products.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No products available yet.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // 2. The Store Banner Layer (Cached via device memory)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: bannerHeight + statusBarHeight,
              child: Obx(() {
                final store = controller.rxStore.value;
                if (store == null || (store.banner ?? '').isEmpty) {
                  return Container(color: Colors.grey[300]);
                }

                return CachedNetworkImage(
                  imageUrl: store.banner!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                );
              }),
            ),

            // 3. The Overlapping Rectangle Logo
            Positioned(
              top: (bannerHeight + statusBarHeight) - 90,
              left: 24,
              right: 24,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Obx(() {
                    final store = controller.rxStore.value;
                    final imagePath = store?.logo ?? '';
                    final bool hasNoImage = imagePath.isEmpty || imagePath == "null" || imagePath.trim().isEmpty;

                    if (hasNoImage) {
                      return Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.store, size: 48, color: Colors.grey),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        width: 130,
                        height: 130,
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[100]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: const Icon(Icons.person, size: 48, color: Colors.grey),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // 4. Floating Action Header Navigation Row
            Positioned(
              top: statusBarHeight + 8,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(Icons.arrow_back, () => Get.back()),
                  Row(
                    children: [
                      _buildIconButton(Icons.share_outlined, () {}),
                      const SizedBox(width: 12),
                      Obx(() => _buildIconButton(
                        controller.isFav.value ? Icons.favorite : Icons.favorite_border,
                            () => controller.toggleFavorite(),
                        color: controller.isFav.value ? Colors.red : Colors.black,
                      )),
                    ],
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