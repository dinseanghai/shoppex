import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/widgets/vender/vender_header.dart';

import '../../controllers/vender_home_controller.dart';

class VenderHomeMenu extends GetView<VenderController> {
  const VenderHomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // This is fixed at the top
            VenderHeader(),

            // This part is scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Add your other content here
                    const Text("Additional scrollable content goes here"),
                    SizedBox(height: 300,),
                    const Text("Additional scrollable content goes here"),
                    SizedBox(height: 300,),
                    const Text("Additional scrollable content goes here"),
                    // Example: ListView.builder for lists...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}