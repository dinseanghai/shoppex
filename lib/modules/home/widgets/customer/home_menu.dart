import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import 'package:shoppex/modules/home/widgets/customer/list_category.dart';
import 'package:shoppex/modules/home/widgets/customer/list_product.dart';
import 'package:shoppex/modules/home/widgets/customer/list_store.dart';
import 'package:shoppex/modules/home/widgets/customer/slide_show_view.dart';

import '../../controllers/customer_home_controller.dart';

class CustomerHomeMenu extends GetView<CustomerController> {
  const CustomerHomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(),
            Row(
              children: [
                _buildNotification(),
                _buildCart(),
              ],
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.homeScrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    _buildUserAddress(),

                    const SizedBox(height: 10),

                    _buildSearchSection(),

                    const SizedBox(height: 12),

                    const SlideShowView(),

                    const SizedBox(height: 6),

                    _buildSectionTitle(
                      'Shop by Category',
                      controller.seeAllCategoryClick,
                    ),

                    const SizedBox(height: 10),

                    const CategoryHorizontalList(),

                    _buildSectionTitle(
                      'Featured Stores',
                      controller.featuredStoreClick,
                    ),

                    const ListStoreView(),

                    _buildSectionTitle(
                      'Trending Products',
                      controller.trendingProductClick,
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              sliver: ListProductView(),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // SECTION TITLE
  // ======================================================
  Widget _buildSectionTitle(
      String title,
      VoidCallback onViewAllTap,
      ) {
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

  // ======================================================
  // SEARCH
  // ======================================================
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Search products, stores...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 15,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 22,
          ),
          suffixIcon: Icon(
            Icons.tune,
            color: Colors.grey[600],
            size: 22,
          ),
        ),
      ),
    );
  }

  // ======================================================
  // ADDRESS
  // ======================================================
  Widget _buildUserAddress() {
    return const Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          color: Colors.blue,
          size: 18,
        ),
        SizedBox(width: 4),
        Text(
          'Deliver to ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            "Response from User's address saved",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black54,
          size: 18,
        ),
      ],
    );
  }

  // ======================================================
  // LOGO
  // ======================================================
  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Shopee',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'X',
                style: TextStyle(
                  color: Color(0xFF3D5AFE),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ======================================================
  // CART
  // ======================================================
  Widget _buildCart() {
    return Obx(
          () => IconButton(
        onPressed: controller.onCartClick,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 28,
              color: Colors.black,
            ),
            if (controller.cartCount.value > 0)
              Positioned(
                right: -5,
                top: -5,
                child: CircleAvatar(
                  radius: 8.5,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${controller.cartCount.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // NOTIFICATION
  // ======================================================
  Widget _buildNotification() {
    return Obx(
          () => IconButton(
        onPressed: controller.onNotificationClick,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_outlined,
              size: 28,
              color: Colors.black,
            ),
            if (controller.notificationCount.value > 0)
              const Positioned(
                right: 2,
                top: 2,
                child: CircleAvatar(
                  radius: 4.5,
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}