import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import 'package:shoppex/modules/home/controllers/home_controller.dart';
import 'package:shoppex/modules/home/widgets/customer/list_store.dart';
import 'package:shoppex/modules/home/widgets/customer/slide_show_view.dart';

import '../../../../data/models/response/list_category.dart';
import 'list_category.dart';

class CustomerHomeMenu extends GetView<HomeController> {
  const CustomerHomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildLogo(),
            Row(children: [buildNotification(), buildCart()]),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              buildUserAddress(),
              const SizedBox(height: 10),
              buildSearchSection(),
              const SizedBox(height: 12),
              SlideShowView(),
              const SizedBox(height: 6),
              buildSectionTitle('Shop by Category', () {
                controller.seeAllCategoryClick();
              }),
              const SizedBox(height: 10),
              const CategoryHorizontalList(),
              buildSectionTitle('Featured Stores', () {
                controller.featuredStoreClick();
              }),
              ListStoreView(),
              buildSectionTitle('Trending Products', () {
                controller.trendingProductClick();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, VoidCallback onViewAllTap) {
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
          onPressed: onViewAllTap, // 2. Assign it here
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

  Container buildSearchSection() {
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
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[600], size: 22),
          suffixIcon: Icon(Icons.tune, color: Colors.grey[600], size: 22),
        ),
      ),
    );
  }

  Row buildUserAddress() {
    return Row(
      children: const [
        Icon(Icons.location_on_outlined, color: Colors.blue, size: 18),
        SizedBox(width: 4),
        Text('Deliver to ', style: TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          "Response from User's address saved",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 13,
          ),
        ),
        Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 18),
      ],
    );
  }

  Row buildLogo() {
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Shopee',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'X',
                style: TextStyle(color: Color(0xFF3D5AFE)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Obx buildCart() {
    return Obx(
      () => IconButton(
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
        onPressed: () => controller.onCartClick(),
      ),
    );
  }

  Obx buildNotification() {
    return Obx(
      () => IconButton(
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
                child: CircleAvatar(radius: 4.5, backgroundColor: Colors.red),
              ),
          ],
        ),
        onPressed: () => controller.onNotificationClick(),
      ),
    );
  }
}
