
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/controllers/home_controller.dart';

class VenderHomeMenu extends GetView<HomeController> {
  const VenderHomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text('Vender Home')
        ],
      ),
    );
  }
}
