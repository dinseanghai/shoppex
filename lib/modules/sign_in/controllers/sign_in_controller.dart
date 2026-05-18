import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../../home/widgets/snackbars.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var isPasswordObscured = true.obs;
  // 1. Inject the NetworkInfo dependency
  final NetworkInfo networkInfo;

  // 2. Network state variables
  final isOnline = true.obs;
  StreamSubscription? _networkSubscription;

  SignInController({required this.networkInfo});

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  @override
  void onInit() {
    super.onInit();
    // 3. Start checking connection as soon as the Sign-In screen initializes
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

  void _handleSnackbar(bool status) {
    if (!status) {
      if (Get.isSnackbarOpen) return;

      final failure = NetworkFailure();
      Snackbars.showNetworkError(failure.message);
    } else {
      if (Get.isSnackbarOpen) {
        Snackbars.closeAll();
        Snackbars.showSuccess();
      }
    }
  }

  @override
  void onClose() {
    // 4. Clean up the subscription when the Sign-In screen is disposed
    _networkSubscription?.cancel();
    super.onClose();
  }
}