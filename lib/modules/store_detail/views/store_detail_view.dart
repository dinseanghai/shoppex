import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import '../../account/widgets/switch_account_type.dart';
import '../controllers/store_detail_controller.dart';
import '../widgets/store_profile.dart';


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
            // 1. The ScrollView
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Adjusted space for profile image overlap
                      SizedBox(height: headerHeight + statusBarHeight + 20),
                      StoreProfile(),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Categories'),
                      const SizedBox(height: 20),

                      SwitchAccountType(
                        icon: Icons.storefront_outlined,
                        title: 'Become a Seller',
                        description: 'Start selling and reach millions of customers',
                        onTap: () {},
                      ),
                      _buildSectionTitle('Top Deals', onViewAllTap: () {
                        // navigate to see all
                      }),
                      const SizedBox(height: 20),
                      SwitchAccountType(
                        icon: Icons.storefront_outlined,
                        title: 'Become a Seller',
                        description: 'Start selling and reach millions of customers',
                        onTap: () {},
                      ),
                      _buildSectionTitle('All Products', onViewAllTap: () {
                        // navigate to see all
                      }),
                      const SizedBox(height: 40),
                      SwitchAccountType(
                        icon: Icons.storefront_outlined,
                        title: 'Become a Seller',
                        description: 'Start selling and reach millions of customers',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. The Banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: bannerHeight + statusBarHeight,
              child: Obx(() {
                final store = controller.rxStore.value;
                if (controller.isDetailsLoading.value || store == null) {
                  return Container(color: Colors.grey[300]);
                }
                return Image.network(
                  store.banner ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                );
              }),
            ),

            // 3. The Profile Image (Overlapping the Banner)
            Positioned(
              top: (bannerHeight + statusBarHeight) - 90,
              left: 24, // Matches your horizontal padding
              right: 24,
              child: Align(
                alignment: Alignment.centerLeft, // This moves only the logo container to the left
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

                    return Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        image: !hasNoImage
                            ? DecorationImage(
                          image: NetworkImage(imagePath),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: hasNoImage
                          ? const Icon(Icons.person, size: 48, color: Colors.grey)
                          : null,
                    );
                  }),
                ),
              ),
            ),

            // 4. Pinned Action Buttons
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

  Widget _buildSectionTitle(
      String title, {
        VoidCallback? onViewAllTap, // Made optional by making it nullable
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        // Only show the button if onViewAllTap is provided
        if (onViewAllTap != null)
          TextButton(
            onPressed: onViewAllTap,
            child: const Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

}