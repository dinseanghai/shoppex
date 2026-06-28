import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/account/views/account_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../routes/app_pages.dart';
import '../services/auth_service.dart';
import '../services/network_service.dart';

class MainLayoutController extends GetxController {
  var currentIndex = 0.obs;
  var isLoggedIn = false.obs;
  var userName = 'Guest'.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      isLoggedIn.value = AuthService.to.hasToken;
    } catch (_) {
      isLoggedIn.value = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (Get.isRegistered<NetworkService>()) {
          Get.find<NetworkService>().activateNetworkChecking();
        }
      } catch (e) {
        debugPrint("NetworkService injection safety catch: $e");
      }
    });
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  bool checkAuthOrRedirect() {
    if (!isLoggedIn.value) {
      Get.toNamed(Routes.SIGNIN);
      return false;
    }
    return true;
  }

  // Pure data definition for Navigation Items
  List<NavigationItemData> get navigationItems {
    final role = AuthService.userRole.value.toLowerCase();

    if (isLoggedIn.value && (role == 'vender' || role == 'vendor')) {
      return [
        NavigationItemData(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', screen: const HomeView()),
        NavigationItemData(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Orders', screen: const Center(child: Text("Orders Management"))),
        NavigationItemData(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'Products', screen: const Center(child: Text("Products Catalog"))),
        NavigationItemData(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Account', screen: const AccountView()),
      ];
    } else {
      return [
        NavigationItemData(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', screen: const HomeView()),
        NavigationItemData(icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart, label: 'Cart', screen: const Center(child: Text("Cart Content"))),
        NavigationItemData(icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search', screen: const Center(child: Text("Search Content"))),
        NavigationItemData(icon: Icons.pending_actions_outlined, activeIcon: Icons.pending_actions, label: 'Activity', screen: const Center(child: Text("Activity Content"))),
        NavigationItemData(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Account', screen: const AccountView()),
      ];
    }
  }
}

// Simple data class to couple Icon, Label, and Screen together safely
class NavigationItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget screen;

  NavigationItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screen,
  });
}

// ==========================================
// VIEW (Modern Floating UI Built-In)
// ==========================================
class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());

    return Obx(() {
      final currentNavItems = controller.navigationItems;

      // Safety check if dynamic switching changes list lengths
      if (controller.currentIndex.value >= currentNavItems.length) {
        controller.currentIndex.value = 0;
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white background looks better with floating cards
        appBar: null,

        // Dynamic screens handled securely via IndexedStack
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: currentNavItems.map((item) => item.screen).toList(),
        ),

        // Modern Floating Bottom Navigation Bar
        bottomNavigationBar: controller.isLoggedIn.value
            ? SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(currentNavItems.length, (index) {
                final isSelected = controller.currentIndex.value == index;
                final item = currentNavItems[index];

                return GestureDetector(
                  onTap: () => controller.changeTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blueAccent.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected ? Colors.blueAccent : const Color(0xFF8E8E93),
                          size: 22,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic,
                          width: isSelected ? 8 : 0,
                          child: const SizedBox(),
                        ),
                        // Smoothly clips/reveals text on active item
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          firstChild: Text(
                            item.label,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          secondChild: const SizedBox.shrink(),
                          crossFadeState: isSelected
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        )
            : null,
      );
    });
  }
}