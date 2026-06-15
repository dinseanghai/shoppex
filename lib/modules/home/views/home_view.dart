import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shoppex/modules/home/controllers/base_home_controller.dart';
import '../widgets/customer/home_menu.dart';
import '../widgets/vender/home_menu.dart';

class HomeView extends GetView<BaseHomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => controller.isVendor.value
          ? const VenderHomeMenu()
          : const CustomerHomeMenu(),
    );
  }
}