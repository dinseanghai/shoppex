import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obx keeps the UI reactive so it can display a loading indicator
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text("HomeScreen"),
        actions: [
          controller.isLoading.value
              ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          )
              : IconButton(
            onPressed: () => controller.confirmLogout(),
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
    ));
  }
}