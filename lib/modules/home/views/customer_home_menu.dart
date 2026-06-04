import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_colors.dart';
import 'package:shoppex/modules/home/controllers/home_controller.dart';


class CustomerHomeMenu extends GetView<HomeController> {
  const CustomerHomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // --- FIXED TOP APP BAR (Row 1: Logo & Action Icons) ---
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Brand Logo Group
            Row(
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
                      TextSpan(text: 'Shopee', style: TextStyle(color: Colors.black)),
                      TextSpan(text: 'X', style: TextStyle(color: Color(0xFF3D5AFE))),
                    ],
                  ),
                ),
              ],
            ),

            // Action Icons (Notification & Cart)
            Row(
              children: [
                Obx(() => IconButton(
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
                  onPressed: () => controller.onNotificationClick(),
                )),
                Obx(() => IconButton(
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
                )),
              ],
            )
          ],
        ),
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // --- COLLAPSIBLE SECTION (Row 2 & Row 3) ---
            SliverAppBar(
              floating: true,
              pinned: false, // Set to true if you want the search bar to stay stuck at the top below the logo
              snap: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              // Reduced height since Row 1 is now in the fixed AppBar above
              expandedHeight: 95.0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  // Removed the top 56.0 padding since we don't need to clear Row 1 anymore
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      // Row 2: Delivery Location
                      Row(
                        children: const [
                          Icon(Icons.location_on_outlined, color: Colors.blue, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Deliver to ',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "Response from User's address saved",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Row 3: Search Bar Configuration
                      Container(
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
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- SCROLLABLE BODY ---
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Trending Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                      title: const Text('Premium Wireless Headphones'),
                      subtitle: const Text('\$149.00', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.grey),
                        onPressed: () => controller.onAddToFavoriteClick(),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}