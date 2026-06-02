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
  var hasNotification = true.obs;
  var cartItemCount = 3.obs;
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
        print("NetworkService injection safety catch: $e");
      }
    });
  }

  // 🟢 FIX: Read directly from AuthService reactive variables
  List<Widget> get bodyScreens {
    // Check if user is logged in AND is a Vendor (case-insensitive check for safety)
    if (isLoggedIn.value && AuthService.userRole.value.toLowerCase() == 'vender' || AuthService.userRole.value == 'Vendor') {
      return const [
        HomeView(),
        Center(child: Text("Orders Management Screen")), // Index 1
        Center(child: Text("Products Catalog Screen")), // Index 2
        AccountView(), // Index 3
      ];
    } else {
      // Default Customer screens
      return const [
        HomeView(),
        Center(child: Text("Cart Screen Content")),
        Center(child: Text("Search Screen Content")),
        AccountView(),
      ];
    }
  }

  // 🟢 FIX: Dynamic navbar items matching the roles
  List<BottomNavigationBarItem> get navItems {
    if (isLoggedIn.value && AuthService.userRole.value.toLowerCase() == 'vender' || AuthService.userRole.value == 'Vendor') {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
      ];
    } else {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
      ];
    }
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

  void openNotifications() {
    if (!checkAuthOrRedirect()) return;
    hasNotification.value = false;
    Get.snackbar("Notifications", "Opening notifications...");
  }

  void openCart() {
    if (!checkAuthOrRedirect()) return;
    changeTab(1);
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());

    return Obx(
          () => Scaffold(
        backgroundColor: Colors.white,
        appBar: controller.currentIndex.value == 0
            ? AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 9, bottom: 9),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_mall_outlined, color: Colors.white, size: 21),
            ),
          ),
          leadingWidth: 52,
          titleSpacing: 8,
          title: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              children: [
                TextSpan(text: 'Shopee', style: TextStyle(color: Colors.black87)),
                TextSpan(text: 'X', style: TextStyle(color: Color(0xFF3D5AFE))),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: controller.openNotifications,
              icon: controller.isLoggedIn.value
                  ? Badge(
                isLabelVisible: controller.hasNotification.value,
                smallSize: 9,
                child: const Icon(Icons.notifications_none_outlined, color: Color(0xFF111111), size: 26),
              )
                  : const Icon(Icons.notifications_none_outlined, color: Color(0xFF111111), size: 26),
            ),

            // 🟢 Fixed: Checking the global AuthService variable safely with case-insensitivity
            if (AuthService.userRole.value.toLowerCase() != 'vendor' && AuthService.userRole.value.toLowerCase() != 'vender')
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: controller.openCart,
                  icon: controller.isLoggedIn.value
                      ? Badge(
                    label: Text(
                      '${controller.cartItemCount.value}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF111111), size: 26),
                  )
                      : const Icon(Icons.shopping_cart_outlined, color: Color(0xFF111111), size: 26),
                ),
              ),
          ],
        )
            : null,
        // 🟢 FIX: Uses dynamic body list getter reactively
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: controller.bodyScreens,
        ),
        bottomNavigationBar: controller.isLoggedIn.value
            ? Container(
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
            // 🟢 FIX: Uses dynamic navbar items array reactively
            items: controller.navItems,
          ),
        )
            : null,
      ),
    );
  }
}