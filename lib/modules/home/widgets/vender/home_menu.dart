
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/controllers/base_home_controller.dart';

class VenderHomeMenu extends GetView<BaseHomeController > {
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
