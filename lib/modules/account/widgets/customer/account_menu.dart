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
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Exact structural measurements to match your design perfectly
    const double blueBannerHeight = 150.0;
    const double totalHeaderHeight = blueBannerHeight + 35; // Banner + half of avatar overlap

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [

            // =========================================================
            // 1. THE SCROLLABLE CONTENT (Name, Email, Settings Lists)
            // Sits at the bottom layer so it slides UNDER the header
            // =========================================================
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // This empty space keeps text content below your fixed header on load
                    SizedBox(height: totalHeaderHeight + statusBarHeight + 16),

                    // ---- SCROLLABLE USER DETAILS & MENUS ----
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const UserProfileHeader(),

                          const SizedBox(height: 16),

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
                              CustomListtile(icon: Icons.person_2_outlined, title: 'Personal Information', subtitle: 'Update your details', onTap: () {}),
                              CustomListtile(icon: Icons.shield_outlined, title: 'Privacy & Security', subtitle: 'Password, 2FA', onTap: () {}),
                            ],
                          ),
                          _buildMenuSection(
                            title: 'Preferences',
                            items: [
                              CustomListtile(icon: Icons.notifications_none_outlined, title: 'Notifications', subtitle: 'Manage your alerts', onTap: () {}),
                              CustomListtile(icon: Icons.language_outlined, title: 'Language', subtitle: 'Get from secure storage', onTap: () {}),
                              CustomListtile(icon: Icons.dark_mode_outlined, title: 'Appearance', subtitle: 'Get from secure storage', onTap: () {}),
                            ],
                          ),

                          _buildMenuSection(
                            title: 'Support',
                            items: [
                              CustomListtile(icon: Icons.help_outline_outlined, title: 'Help Center', subtitle: 'FAQs and support', onTap: () {}),
                              CustomListtile(icon: Icons.article_outlined, title: 'Term & Policies', subtitle: 'Legal information', onTap: () {}),
                            ],
                          ),



                          // Sign Out Option
                          CustomListtile(
                            icon: Icons.logout_rounded,
                            title: 'Sign Out',
                            iconColor: Colors.redAccent,
                            iconBgColor: const Color(0xFFFFF1F1),
                            showTrailing: false,
                            onTap: () => controller.confirmLogout(),
                          ),

                          const SizedBox(height: 10), // Extra cushion so bottom items clear nav bars
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // 2. FIXED FOREGROUND LAYER (Blue Background + Profile Avatar)
            // Placed at the bottom of the Stack so it renders ON TOP of scrolling text
            // =========================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: totalHeaderHeight + statusBarHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Blue Gradient Banner
                  Container(
                    height: blueBannerHeight + statusBarHeight,
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
                    child: SafeArea(
                      bottom: false,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: kToolbarHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 40), // Balances settings icon alignment
                              const Text(
                                'My Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: controller.onEditProfilePressed,
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Fixed Profile Avatar (Layered strictly inside the fixed top stack)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
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
                            // Changed the semicolon (;) to a comma (,) right here:
                            child: hasNoImage
                                ? Icon(Icons.person, size: 48, color: Colors.grey[400])
                                : null,
                          );
                        }),
                      ),
                    ),
                  ),
                ],
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
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
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