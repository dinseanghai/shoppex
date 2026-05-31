import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import '../../modules/home/views/home_view.dart';

class MainLayoutController extends GetxController {
  var currentIndex = 0.obs;

  var hasNotification = true.obs;
  var cartItemCount = 3.obs;

  // 1. Updated to hold all 4 screens corresponding to the bottom navigation bar
  final List<Widget> bodyScreens = [
    const HomeView(),
    const Center(child: Text("Cart Screen Content")),
    const Center(child: Text("Search Screen Content")),
    const Center(child: Text("Account Screen Content")),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void openNotifications() {
    hasNotification.value = false;
    Get.snackbar("Notifications", "Opening notifications...");
  }

  void openCart() {
    // Switch to the Cart tab directly when top-right cart is tapped
    changeTab(1);
  }
}

// =========================================================================
// VIEW
// =========================================================================
class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Putting the controller into memory
    final controller = Get.put(MainLayoutController());

    return Scaffold(
      // Explicitly set background color to override any inherited builder dark layers
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_mall_outlined, color: Colors.white, size: 16),
          ),
        ),
        leadingWidth: 52,
        titleSpacing: 8,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            children: [
              TextSpan(text: 'Shopee',),
              TextSpan(text: 'X',),
            ],
          ),
        ),
        actions: [
          Obx(() => IconButton(
            onPressed: controller.openNotifications,
            icon: Badge(
              isLabelVisible: controller.hasNotification.value,

              smallSize: 9,
              child: const Icon(Icons.notifications_none_outlined, color: Color(0xFF111111), size: 26),
            ),
          )),
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: controller.openCart,
              icon: Badge(
                label: Text(
                  '${controller.cartItemCount.value}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),

                child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF111111), size: 26),
              ),
            ),
          )),
        ],
      ),
      // Pushes screens safely below the top appbar
      body: Obx(
            () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.bodyScreens,
        ),
      ),
      bottomNavigationBar: Obx(
            () => Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: const Color(0xFF666666),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.search_outlined),activeIcon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
            ],
          ),
        ),
      ),
    );
  }
}