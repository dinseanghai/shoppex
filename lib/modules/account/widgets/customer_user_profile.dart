import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class UserProfileHeader extends GetView<AccountController> {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const Color darkSlateContentColor = Color(0xFF334155);

    // Sophisticated Light Gray / Slate-Platinum Gradient
    const List<Color> headerGradientColors = [
      Color(0xFF4A65FF), // Vibrant blue on the left
      Color(0xFF94A6FD), // Slightly lighter blue on the right
    ];

    return Column(
      children: [
        // 1. Header Banner Stack
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Gray Gradient Background Banner
            Container(
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

            // Navigation Bar (Title & Action)
            Positioned(
              top: statusBarHeight + 2,
              left: 16,
              right: 16,
              child: SizedBox(
                height: kToolbarHeight,
                child: NavigationToolbar(
                  middle: const Text(
                    'My Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: controller.onEditProfilePressed,
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            // Profile Avatar Container
            Positioned(
              bottom: -40,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Subtle soft shadow depth
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(() {
                  final imagePath = controller.userImageUrl.value;
                  final bool hasNoImage = imagePath.isEmpty ||
                      imagePath == "null" ||
                      imagePath.trim().isEmpty;

                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: !hasNoImage
                        ? NetworkImage(imagePath) as ImageProvider
                        : null,
                    child: hasNoImage
                        ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                        : null,
                  );
                }),
              ),
            ),
          ],
        ),

        // Displacement Spacer
        const SizedBox(height: 45),

        // 2. Profile Server Info Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // User Name Text String
              Obx(() => Text(
                controller.userName.value.isNotEmpty ? controller.userName.value : 'Loading...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )),

              // Reactive User Role Badge (Collapses cleanly if empty)
              Obx(() {
                final roleStr = controller.userRole.value.trim();
                if (roleStr.isEmpty) {
                  return const SizedBox.shrink();
                }

                final normalizedRole = roleStr.toLowerCase();
                final isVendor = normalizedRole == 'vender' || normalizedRole == 'vendor';

                final Color roleColor = isVendor ? const Color(0xFF10B981) : const Color(0xFF0284C7);
                final Color roleBgColor = isVendor ? const Color(0xFFE6F4EA) : const Color(0xFFE0F2FE);

                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    decoration: BoxDecoration(
                      color: roleBgColor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      roleStr,
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 4),

              // Email Address Info Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 6),
                  Obx(() => Text(
                    controller.userEmail.value.isNotEmpty ? controller.userEmail.value : '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}