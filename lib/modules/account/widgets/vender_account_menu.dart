import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/modules/account/widgets/switch_account_type.dart';
import 'package:shoppex/modules/account/widgets/vender_user_profile.dart';

import '../../../shared/widgets/custom_listtile.dart';
import '../controllers/account_controller.dart';

class VenderAccountMenu extends GetView<AccountController> {
  const VenderAccountMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          children: [
            VendorUserProfile(controller: controller),
            AppSizes.gapH24,
            SwitchAccountType(
              icon: Icons.person_outline,
              title: 'Become a customer',
              description:
                  'Browse thousand of product, place order shipping, enjoy your moments',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Account'),
            CustomListtile(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Name, email, phone',
              onTap: () {},
            ),
            CustomListtile(
              icon: Icons.storefront_outlined,
              title: 'Store Details',
              subtitle: 'Name, email, phone',
              onTap: () {},
            ),
            buildLogOut(),
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
          shadowColor: Colors.black.withOpacity(
            0.4,
          ), // Controls shadow color/opacity
          elevation: 4, // Controls the depth/size of the shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red, size: 24),
            AppSizes.gapW8,
            Text(
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
      // 2. Added horizontal padding so the header doesn't touch the very edge of the screen
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}
