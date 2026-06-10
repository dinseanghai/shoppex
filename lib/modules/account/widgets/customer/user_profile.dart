import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/account_controller.dart';

class UserProfileHeader extends GetView<AccountController> {
  final double statusBarHeight;
  const UserProfileHeader({super.key, required this.statusBarHeight});

  @override
  Widget build(BuildContext context) {
    const List<Color> headerGradientColors = [
      Color(0xFF4A65FF),
      Color(0xFF7286E4),
    ];

    return SizedBox(
      height: 240, // Keeps total area bounded safely above the scrolling list
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Blue Gradient Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
          ),

          // Header Content (Title & Settings Icon)
          Positioned(
            top: statusBarHeight + 2,
            left: 16,
            right: 16,
            child: SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                middle: const Text(
                  'My Account',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  onPressed: controller.onEditProfilePressed,
                  icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),

          // Profile Avatar fixed on the edge
          Positioned(
            bottom: 0, // Snaps perfectly to the base of our 240px container box
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Obx(() {
                final imagePath = controller.userImageUrl.value;
                final bool hasNoImage = imagePath.isEmpty || imagePath == "null" || imagePath.trim().isEmpty;

                return CircleAvatar(
                  radius: 56, // Slightly optimized size to match the crisp design bounds
                  backgroundColor: Colors.grey[100],
                  backgroundImage: !hasNoImage ? NetworkImage(imagePath) as ImageProvider : null,
                  child: hasNoImage ? Icon(Icons.person, size: 50, color: Colors.grey[400]) : null,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. SCROLLABLE STRINGS: This block rolls up naturally when you swipe up
class UserProfileInfoStrings extends GetView<AccountController> {
  const UserProfileInfoStrings({super.key});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // User Name String
          Obx(() => Text(
            controller.userName.value.isNotEmpty ? controller.userName.value : '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          )),

          // User Role Badge
          Obx(() {
            final roleStr = controller.userRole.value.trim();
            if (roleStr.isEmpty) return const SizedBox.shrink();

            final normalizedRole = roleStr.toLowerCase();
            final isVendor = normalizedRole == 'vender' || normalizedRole == 'vendor';

            final Color roleColor = isVendor ? const Color(0xFF10B981) : const Color(0xFF0284C7);
            final Color roleBgColor = isVendor ? const Color(0xFFE6F4EA) : const Color(0xFFE0F2FE);

            return Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: roleBgColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  roleStr,
                  style: TextStyle(color: roleColor, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            );
          }),

          // Email Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mail_outline_rounded, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Obx(() => Text(
                controller.userEmail.value.isNotEmpty ? controller.userEmail.value : '',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              )),
            ],
          ),
        ],
      ),
    );
  }
}