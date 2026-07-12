import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../home/widgets/customer/list_product.dart';
import '../controllers/all_product_controller.dart';

class AllProductView extends GetView<AllProductController> {
  const AllProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 1. Hide the default back button
        automaticallyImplyLeading: false,
        // 2. Add your custom button to the leading slot
        leading: Center(
          child: _buildIconButton(Icons.arrow_back, () => Get.back()),
        ),
        title: const Text("All Products",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),),
      ),
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: const [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: ListProductView(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: Colors.black, size: 20),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
