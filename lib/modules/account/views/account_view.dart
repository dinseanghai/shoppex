import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/services/auth_service.dart';
import '../controllers/customer_account_controller.dart';
import '../controllers/vender_account_controller.dart';
import '../widgets/customer/account_menu.dart';
import '../widgets/vender/account_menu.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        final role = AuthService.userRole.value.trim().toLowerCase();
        final isVendor = role == 'vendor' || role == 'vender';

        if (isVendor) {
          // Clean up customer controller if it was lingering
          if (Get.isRegistered<CustomerAccountController>()) {
            Get.delete<CustomerAccountController>();
          }
          Get.put(VenderAccountController()); // spelling matched to your log "VenderAccountController"
          return const VenderAccountMenu();
        } else {
          // Clean up vendor controller if it was lingering
          if (Get.isRegistered<VenderAccountController>()) {
            Get.delete<VenderAccountController>();
          }
          Get.put(CustomerAccountController());
          return const CustomerAccountMenu();
        }
      }),
    );
  }
}