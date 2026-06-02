import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';

class CustomerAccountMenu extends GetView<AccountController> {
  const CustomerAccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    const Color primaryPurple = Color(0xFF3B59F6);

    return Column(
      children: [
        // 1. Header Profile Banner (Uses inherited controller seamlessly)
        buildHeader(primaryPurple, context),
        const SizedBox(height: 45),

        // 2. User Meta Profile Data Block wrapped in a single Obx
        Obx(() {
          final isVendor = controller.userRole.value.trim().toLowerCase() == 'vender' ||
              controller.userRole.value.trim().toLowerCase() == 'vendor';
          final Color roleColor = isVendor ? const Color(0xFF10B981) : const Color(0xFF0284C7);
          final Color roleBgColor = isVendor ? const Color(0xFFE6F4EA) : const Color(0xFFE0F2FE);

          return buildUserInformation(roleBgColor, roleColor);
        }),
        const SizedBox(height: 30),

        // 3. Become a Seller Advertising Banner Card Layout
        buildBecomeSeller(),
        const SizedBox(height: 30),

        // 4. Target Settings Categories (Your Custom Menu Items)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                leading: const Icon(Icons.favorite_border, color: Colors.black),
                title: const Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {},
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                leading: const Icon(Icons.location_on_outlined, color: Colors.black),
                title: const Text('Shipping Addresses', style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBecomeSeller() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF4D72FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Become a Seller',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start selling and reach millions of customers',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4D72FF),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              onPressed: () => {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInformation(Color roleBgColor, Color roleColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(
            controller.userName.value.isNotEmpty ? controller.userName.value : 'User Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 6),
              Text(
                controller.userEmail.value.isNotEmpty ? controller.userEmail.value : 'No Email Assigned',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
            decoration: BoxDecoration(
              color: roleBgColor,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              controller.userRole.value.isNotEmpty ? controller.userRole.value : 'Customer',
              style: TextStyle(
                color: roleColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack buildHeader(Color primaryPurple, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: primaryPurple,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          child: const Text(
            'My Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 2,
          right: 16,
          child: IconButton(
            onPressed: controller.onEditProfilePressed,
            icon: const Icon(Icons.settings, color: Colors.white, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Obx(
                  () => CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(
                  controller.profileImageUrl.value.isNotEmpty
                      ? controller.profileImageUrl.value
                      : 'https://placeholder.com/user.png',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}