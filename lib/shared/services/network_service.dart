import 'dart:async';
import 'package:get/get.dart';
import 'package:shoppex/shared/widgets/snackbars.dart';
import '../../core/network/network_info.dart';

class NetworkService extends GetxController {
  final NetworkInfo networkInfo = Get.find<NetworkInfo>();
  StreamSubscription? _networkSubscription;

  final isOnline = true.obs;

  // 🔥 NEW SOURCE OF TRUTH: Tells the UI whether it's allowed to show the glass blur
  final isOverlayAllowed = false.obs;

  bool _isShowingSuccessSnackbar = false;

  @override
  void onInit() {
    super.onInit();
    _listenToNetworkChanges();
  }

  void _listenToNetworkChanges() {
    _networkSubscription = networkInfo.onStatusChange.listen((status) {
      isOnline.value = status;
      _handleSnackbar(status);
    });
  }

  /// 🔥 FORCE AN IMMEDATE CHECK & UNLOCK TARGET FROM SIGN-IN CONTROLLER
  void enableBlockerAndCheck() async {
    // 1. Immediately reveal the overlay layer structure smoothly
    isOverlayAllowed.value = true;

    // 2. Fetch hardware asset info and update tracking parameters
    final currentConnection = await networkInfo.isConnected;
    isOnline.value = currentConnection;
  }

  void _handleSnackbar(bool status) {
    if (!status) {
      _isShowingSuccessSnackbar = false;
    } else {
      if (_isShowingSuccessSnackbar) return;

      if (Get.isSnackbarOpen || !isOnline.value) {
        _isShowingSuccessSnackbar = true;

        Snackbars.closeAll();
        Snackbars.showSuccess();

        Future.delayed(const Duration(seconds: 2), () {
          _isShowingSuccessSnackbar = false;
        });
      }
    }
  }

  @override
  void onClose() {
    _networkSubscription?.cancel();
    super.onClose();
  }
}