import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_string.dart';
import 'dart:async';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../widgets/snackbars.dart';

class HomeController extends GetxController {
  final NetworkInfo networkInfo;
  final isOnline = true.obs;
  StreamSubscription? _networkSubscription;

  HomeController({required this.networkInfo});

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
    _listenToNetworkChanges();
  }

  void _checkInitialStatus() async {
    final status = await networkInfo.isConnected;
    isOnline.value = status;
    _handleSnackbar(status);
  }

  void _listenToNetworkChanges() {
    _networkSubscription = networkInfo.onStatusChange.listen((status) {
      isOnline.value = status;
      _handleSnackbar(status);
    });
  }

  // Declare a variable to keep track of the active snackbar
  SnackbarController? _connectionSnackbar;

  void _handleSnackbar(bool status) {
    if (!status) {
      // 1. Check if already showing to avoid duplicates
      if (Get.isSnackbarOpen) return;

      // 2. Create the Failure object to get the message
      final failure = NetworkFailure();

      // 3. Call the reusable static method
      Snackbars.showNetworkError(failure.message);

    } else {
      // 4. If back online, close the error and show success
      if (Get.isSnackbarOpen) {
        Snackbars.closeAll();
        Snackbars.showSuccess();
      }
    }
  }

  @override
  void onClose() {
    _networkSubscription?.cancel();
    super.onClose();
  }
}