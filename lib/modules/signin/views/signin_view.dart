import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/signin_controller.dart';

class SigninView extends StatelessWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inject the controller and pass the registered NetworkInfo dependency
    final controller = Get.put(SignInController(networkInfo: Get.find()));

    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: Obx(() {
          return ElevatedButton(
            // The button will automatically disable itself if the network drops
            onPressed: controller.isOnline.value
                ? () => _performLogin()
                : null,
            child: const Text("Sign In"),
          );
        }),
      ),
    );
  }

  void _performLogin() {
    // Your login implementation (e.g., Get.toNamed('/home'))
  }
}