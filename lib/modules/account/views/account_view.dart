import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../widgets/customer/account_menu.dart';
import '../widgets/vender/account_menu.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Clean global background canvas
      body: Obx(() {
        // Dynamic conditional view selection driven by state variables
        if (controller.isVendor) {
          return const VenderAccountMenu();
        } else {
          return const CustomerAccountMenu();
        }
      }),
    );
  }
} 