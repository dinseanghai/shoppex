import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../widgets/customer_account_menu.dart';
import '../widgets/vender_account_menu.dart';

// Inside account_view.dart
class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🟢 Automatically swap the entire screen design depending on the logged-in role
      if (controller.isVendor) {
        return const VenderAccountMenu();   // Completely matches your dark/grid design
      } else {
        return const CustomerAccountMenu(); // Completely matches your light/list design
      }
    });
  }
}
