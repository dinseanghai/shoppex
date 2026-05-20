import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../dependency_injection.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Scaffold(
      appBar: AppBar(title: const Text("HomeScreen")),

    );
=======
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
            onPressed: () async {
              await DependencyInjection.logout();
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
    ));
>>>>>>> Stashed changes
  }
}