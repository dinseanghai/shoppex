import 'dart:async';
import 'package:get/get.dart';
import 'package:shoppex/shared/widgets/snackbars.dart';
import '../../core/network/network_info.dart';
import '../../routes/app_pages.dart';

class NetworkService extends GetxController {
  final NetworkInfo networkInfo = Get.find<NetworkInfo>();
  StreamSubscription? _networkSubscription;

  final isOnline = true.obs;
  final isOverlayAllowed = false.obs;

  bool _isShowingSuccessSnackbar = false;

  // ⭐ ADDED: Tracking flag to skip the initial stream notification on app boot
  bool _isFirstCheck = true;

  @override
  void onInit() {
    super.onInit();
    _listenToNetworkChanges();
  }

  /// ⭐ THE NEW MASTER METHOD
  void activateNetworkChecking() async {
    isOverlayAllowed.value = true;

    // Check instantly to see if they are already offline when arriving
    final currentConnection = await networkInfo.isConnected;
    isOnline.value = currentConnection;
  }

  /// ⭐ BACKWARD COMPATIBILITY ALIAS
  /// This points directly to the new method, keeping old references safe.
  void enableBlockerAndCheck() {
    activateNetworkChecking();
  }

  void _listenToNetworkChanges() {
    _networkSubscription = networkInfo.onStatusChange.listen((status) {
      isOnline.value = status;
      _handleSnackbar(status);
    });
  }

  void _handleSnackbar(bool status) {
    // 1. FIRST BOOT GUARD: Run this completely independent of what screen the user is on
    if (status && _isFirstCheck) {
      _isFirstCheck = false; // Turn off the flag so future toggles work perfectly
      return;
    }

    // 2. ROUTE FILTER: Now check if they are on onboarding screens
    if (_isOnboarding()) return;

    if (!status) {
      // If they go offline, it's definitely no longer the first check
      _isFirstCheck = false;
      _isShowingSuccessSnackbar = false;
    } else {
      if (_isShowingSuccessSnackbar) return;

      _isShowingSuccessSnackbar = true;
      Snackbars.closeAll();
      Snackbars.showBackOnline();

      Future.delayed(const Duration(seconds: 3), () {
        _isShowingSuccessSnackbar = false;
      });
    }
  }

  bool _isOnboarding() {
    final current = Get.currentRoute;
    return current == Routes.ONBOARDING || current == '/' || current.isEmpty;
  }

  @override
  void onClose() {
    _networkSubscription?.cancel();
    super.onClose();
  }
}