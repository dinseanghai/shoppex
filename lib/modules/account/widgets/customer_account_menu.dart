import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import 'package:shoppex/modules/account/widgets/customer_user_profile.dart';
import 'package:shoppex/modules/account/widgets/switch_account_type.dart';
import '../controllers/account_controller.dart';

class CustomerAccountMenu extends GetView<AccountController> {
  const CustomerAccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: It's better to manage SystemChrome styles inside AccountController's onInit()
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return SingleChildScrollView(
      // <--- Added to prevent overflow errors
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          UserProfileHeader(
            title: 'My Account',
            imageUrl: controller.userImageUrl,
            userName: controller.userName,
            userEmail: controller.userEmail,
            userRole: controller.userRole,
            rightAction: IconButton(
              onPressed: controller.onEditProfilePressed,
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SwitchAccountType(
              icon: Icons.storefront_outlined,
              title: 'Become a Seller',
              description: 'Start selling and reach millions of customers',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
