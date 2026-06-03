import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileHeader extends StatelessWidget {
  final String title;

  // Dynamic Server Responses (GetX Observables)
  final RxString imageUrl;
  final RxString userName;
  final RxString userEmail;
  final RxString userRole;

  // Optional Configurations (With Defaults)
  final List<Color>? headerGradientColors;
  final bool showBackButton;
  final Widget? rightAction;

  UserProfileHeader({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.userName,
    required this.userEmail,
    RxString? userRole,
    // 🟢 Sophisticated Light Gray / Slate-Platinum Gradient
    this.headerGradientColors = const [
      Color(0xFF4A65FF), // Vibrant blue on the left
      Color(0xFF94A6FD), // Slightly lighter blue on the right
    ],
    this.showBackButton = false,
    this.rightAction,
  })  : userRole = userRole ?? ''.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Dark Slate color for crisp typography contrast against the light gray banner
    const Color darkSlateContentColor = Color(0xFF334155);

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
              decoration: BoxDecoration(
                gradient: headerGradientColors != null
                    ? LinearGradient(
                  colors: headerGradientColors!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),

            // Navigation Bar (Back, Title, Right Action)
            Positioned(
              top: statusBarHeight + 2,
              left: 16,
              right: 16,
              child: SizedBox(
                height: kToolbarHeight,
                child: NavigationToolbar(
                  leading: showBackButton
                      ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: darkSlateContentColor, size: 20),
                    onPressed: () => Get.back(),
                  )
                      : null,
                  middle: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: rightAction,
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
                  final imagePath = imageUrl.value;
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
                          : null);
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
                userName.value.isNotEmpty ? userName.value : 'Loading...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )),

              // Reactive User Role Badge (Collapses cleanly if empty)
              Obx(() {
                final roleStr = userRole.value.trim();
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
                      // Add the boxShadow property here
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
                    userEmail.value.isNotEmpty ? userEmail.value : '',
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