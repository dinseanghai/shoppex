import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController(networkInfo: Get.find()));
    return Scaffold(
      appBar: AppBar(title: const Text("HomeScreen")),
      body: Center(
        child: Obx(() {
          // This block rebuilds whenever controller.isOnline changes
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                controller.isOnline.value ? Icons.wifi : Icons.wifi_off,
                size: 100,
                color: controller.isOnline.value ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                controller.isOnline.value
                    ? "Connected to the Internet"
                    : "No Connection Available",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }),
      ),
    );
  }
}