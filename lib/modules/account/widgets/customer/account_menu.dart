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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        // 1. Align all children in the Column to the start (left)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserProfileHeader(),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SwitchAccountType(
              icon: Icons.storefront_outlined,
              title: 'Become a Seller',
              description: 'Start selling and reach millions of customers',
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          _buildSectionHeader('Account Settings'),
          CustomListtile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Update your details',

            onTap: () {},
          ),
          CustomListtile(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            subtitle: 'Manage your alerts',
            onTap: () {},
          ),
          CustomListtile(
            icon: Icons.shield_outlined,
            title: 'Privacy & Security',
            subtitle: 'Password, 2FA',
            onTap: () {},
          ),
          _buildSectionHeader('Support'),
          CustomListtile(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            subtitle: 'FAQs and support',
            onTap: () {},
          ),
          CustomListtile(
            icon: Icons.article_outlined,
            title: 'Terms & Policies',
            subtitle: 'Legal Informations',
            onTap: () {},
          ),
          AppSizes.gapH12,
          CustomListtile(
            icon: Icons.logout_rounded,
            title: 'Sign Out',
            iconColor: Colors.redAccent,
            iconBgColor: const Color(0xFFFFF1F1),
            showTrailing: false,
            onTap: () => controller.confirmLogout(),
          ),
          AppSizes.gapH12,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      // 2. Added horizontal padding so the header doesn't touch the very edge of the screen
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}
