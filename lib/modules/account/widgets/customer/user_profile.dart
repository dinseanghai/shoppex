import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base_account_controller.dart';

class UserProfileHeader extends GetView<BaseAccountController> {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name Block
        Obx(() => Text(
          controller.userName.value.isNotEmpty ? controller.userName.value : '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        )),

        // Role Badge Block
        Obx(() {
          final roleStr = controller.userRole.value.trim();
          if (roleStr.isEmpty) return const SizedBox.shrink();

          // 🟢 Uses the shared getter from BaseAccountController
          final isVendor = controller.isVendor;

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