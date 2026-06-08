import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/modules/account/widgets/switch_account_type.dart';
import 'package:shoppex/modules/account/widgets/vender/user_profile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_listtile.dart';
import '../../controllers/account_controller.dart';

class VenderAccountMenu extends GetView<AccountController> {
  const VenderAccountMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String documentStatus = '';
    bool isBiometricsEnabled = true;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns content to the start (left)
          children: [
            AppSizes.gapH12,
            VendorUserProfile(controller: controller),
            AppSizes.gapH24,
            SwitchAccountType(
              icon: Icons.person_outline,
              title: 'Become a customer',
              description:
                  'Browse thousand of product, place order shipping, enjoy your moments',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Section Title aligned to start
            _buildSectionHeader('ACCOUNT'),
            const SizedBox(height: 8),

            // Framed Container mimicking image_6bdc5e.png
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomListtile(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Name, email, phone',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.storefront_outlined,
                    title: 'Store Details',
                    subtitle: 'Response Store Name',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    subtitle: 'Response Store address',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.assignment_outlined,
                    title: 'Business Documents',
                    subtitle: 'Tax ID, License',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: documentStatus == 'verified'
                            ? const Color(0xE8E5FBEB)
                            : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        documentStatus == 'verified' ? 'Verified' : 'Pending',
                        style: TextStyle(
                          color: documentStatus == 'verified'
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFE65100),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('PAYMENTS & SECURITY'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomListtile(
                    icon: Icons.payment_outlined,
                    title: 'Payout Methods',
                    subtitle: 'Response payment method',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.lock_outline,
                    title: 'Password',
                    subtitle: 'Response last updated password',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.phonelink_lock,
                    title: 'Two-Factor Auth',
                    subtitle: isBiometricsEnabled
                        ? 'Response 2FA provider'
                        : 'Face ID Disabled',
                    trailing: Transform.scale(
                      scale: 0.8, // Shrinks the switch size down to 80%
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: isBiometricsEnabled,
                        onChanged: (value) {
                          // update state
                        },
                        activeTrackColor: const Color(
                          0xFF1A1A1A,
                        ), // Sleek off-black track
                        inactiveTrackColor: const Color(
                          0xFFE5E5EA,
                        ), // Light grey when off
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ), // Removes borders
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.fingerprint,
                    title: 'Biometric Login',
                    subtitle: isBiometricsEnabled
                        ? 'Face ID Enabled'
                        : 'Face ID Disabled',
                    trailing: Transform.scale(
                      scale: 0.8, // Shrinks the switch size down to 80%
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: isBiometricsEnabled,
                        onChanged: (value) {
                          // update state
                        },
                        activeTrackColor: const Color(
                          0xFF1A1A1A,
                        ), // Sleek off-black track
                        inactiveTrackColor: const Color(
                          0xFFE5E5EA,
                        ), // Light grey when off
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ), // Removes borders
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('PREFERENCES'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomListtile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Orders, payout, alert',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'Get from secure storage',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Appearance',
                    subtitle: 'Get from secure storage',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('SUPPORT'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomListtile(
                    icon: Icons.support_outlined,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.chat_bubble_outline_outlined,
                    title: 'Contact Support',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CustomListtile(
                    icon: Icons.article_outlined,
                    title: 'Term & Privacy',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 45),
            buildLogOut(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  SizedBox buildLogOut() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: TextButton(
        onPressed: () => controller.confirmLogout(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.4),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.red, size: 24),
            AppSizes.gapW8,
            const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      // Left padding adjusted to align natively with the rest of the layout edges
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title.toUpperCase(), // Uppercased to match design image
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}
