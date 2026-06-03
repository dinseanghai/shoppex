import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Return a Scaffold at the root of your view
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: LoadingWidget(
              size: 50.0,
              isButtonMode: false,
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Safe spacing for status bar padding if you don't use a standard AppBar
              const SizedBox(height: 12),
              AppSizes.gapH8,

              GestureDetector(
                onTap: controller.changeLocation,
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.blue, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      'Deliver to ',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      controller.deliveryLocation.value,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                  ],
                ),
              ),
              AppSizes.gapH16,

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onSubmitted: controller.executeSearch,
                  decoration: InputDecoration(
                    hintText: 'Search products, stores...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.grey),
                      onPressed: controller.openFilters,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24), // Added spacing before the logout button

              Center(
                child: ElevatedButton(
                  onPressed: () => controller.confirmLogout(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Logout Test", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}