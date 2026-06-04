import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/views/customer_home_menu.dart';
import 'package:shoppex/modules/home/views/vender_home_menu.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // Dynamic conditional view selection driven by state variables
        if (controller.isVendor) {
          return const VenderHomeMenu();
        } else {
          return const CustomerHomeMenu();
        }
      }),
    );
  }
}