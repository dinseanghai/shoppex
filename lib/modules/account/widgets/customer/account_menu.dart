import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/modules/account/widgets/customer/user_profile.dart';
import 'package:shoppex/modules/account/widgets/switch_account_type.dart';
import 'package:shoppex/shared/widgets/custom_listtile.dart';
import '../../controllers/account_controller.dart';

class CustomerAccountMenu extends GetView<AccountController> {
  const CustomerAccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 20.0;

    // Status bar adjustment variables
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const double appBarHeight = kToolbarHeight;
    const double totalHeaderHeight = 220.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        // Forces light text/icons in the status bar over your blue background
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. STICKY / PINNED HEADER
            SliverAppBar(
              pinned: true,
              expandedHeight: totalHeaderHeight,
              toolbarHeight: appBarHeight,
              backgroundColor: const Color(0xFF4A65FF), // Fallback base color
              elevation: 0,
              // Hides standard back/menu items if unnecessary
              automaticallyImplyLeading: false,
              titleSpacing: 0,

              // Custom Action Header Overlay
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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

              // The Blue Background & Avatar Stack
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blue Banner (Extends all the way up through the status bar)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4A65FF), Color(0xFF7286E4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                    ),

                    // Floating Profile Avatar Frame
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
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
                            radius: 54,
                            backgroundColor: Colors.grey[100],
                            backgroundImage: !hasNoImage
                                ? NetworkImage(imagePath) as ImageProvider
                                : null,
                            child: hasNoImage
                                ? Icon(Icons.person, size: 48, color: Colors.grey[400])
                                : null,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. SCROLLABLE BODY CONTENT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // User Text details (Name, Badge, Email)
                    const UserProfileInfoStrings(),

                    const SizedBox(height: 24),

                    // "Become a Seller" Action Card
                    SwitchAccountType(
                      icon: Icons.storefront_outlined,
                      title: 'Become a Seller',
                      description: 'Start selling and reach millions of customers',
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),

                    // Organized Settings Blocks
                    _buildMenuSection(
                      title: 'Account Settings',
                      items: [
                        CustomListtile(icon: Icons.language_outlined, title: 'Language', subtitle: 'Get from secure storage', onTap: () {}),
                        CustomListtile(icon: Icons.dark_mode_outlined, title: 'Appearance', subtitle: 'Get from secure storage', onTap: () {}),
                      ],
                    ),
                    _buildMenuSection(
                      title: 'Preferences',
                      items: [
                        CustomListtile(icon: Icons.language_outlined, title: 'Language', subtitle: 'Get from secure storage', onTap: () {}),
                        CustomListtile(icon: Icons.dark_mode_outlined, title: 'Appearance', subtitle: 'Get from secure storage', onTap: () {}),
                      ],
                    ),
                    _buildMenuSection(
                      title: 'Support',
                      items: [
                        CustomListtile(icon: Icons.language_outlined, title: 'Language', subtitle: 'Get from secure storage', onTap: () {}),
                        CustomListtile(icon: Icons.dark_mode_outlined, title: 'Appearance', subtitle: 'Get from secure storage', onTap: () {}),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Sign Out Option
                    CustomListtile(
                      icon: Icons.logout_rounded,
                      title: 'Sign Out',
                      iconColor: Colors.redAccent,
                      iconBgColor: const Color(0xFFFFF1F1),
                      showTrailing: false,
                      onTap: () => controller.confirmLogout(),
                    ),

                    const SizedBox(height: 40), // Safe scroll cushion at bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    List<Widget> childrenWithDividers = [];
    for (int i = 0; i < items.length; i++) {
      childrenWithDividers.add(items[i]);
      if (i < items.length - 1) {
        childrenWithDividers.add(const Divider(height: 1, indent: 16, endIndent: 16));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: childrenWithDividers),
        ),
      ],
    );
  }
}

/// Dynamic text descriptors widget
class UserProfileInfoStrings extends GetView<AccountController> {
  const UserProfileInfoStrings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name Block
        Obx(() => Text(
          controller.userName.value.isNotEmpty ? controller.userName.value : 'Loading...',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        )),

        // Role Badge Block
        Obx(() {
          final roleStr = controller.userRole.value.trim();
          if (roleStr.isEmpty) return const SizedBox.shrink();

          final normalizedRole = roleStr.toLowerCase();
          final isVendor = normalizedRole == 'vender' || normalizedRole == 'vendor';

          final Color roleColor = isVendor ? const Color(0xFF10B981) : const Color(0xFF0284C7);
          final Color roleBgColor = isVendor ? const Color(0xFFE6F4EA) : const Color(0xFFE0F2FE);

          return Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Center(
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
            ),
          );
        }),

        // Email Row Block
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
    );
  }
}