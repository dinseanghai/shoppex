import 'dart:async';
import 'package:get/get.dart';
import 'package:shoppex/shared/widgets/snackbars.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../routes/app_pages.dart';

class NetworkService extends GetxController {
  final NetworkInfo networkInfo = Get.find<NetworkInfo>();
  StreamSubscription? _networkSubscription;

  final isOnline = true.obs;

  bool _lastRecordedState = true;
  bool _isShowingSuccessSnackbar = false;

  @override
  void onInit() {
    super.onInit();
    _listenToNetworkChanges();
  }

  void _listenToNetworkChanges() {
    _networkSubscription = networkInfo.onStatusChange.listen((status) {
      if (_lastRecordedState == status) return;
      _lastRecordedState = status;

      isOnline.value = status;

      // Calculate route matching variables
      String realPageRoute = Get.currentRoute;
      if (realPageRoute.contains('rawSnackbar') || Get.isSnackbarOpen) {
        realPageRoute = Get.previousRoute;
      }

      // SKIP SNACKBARS FOR ONBOARDING:
      // If the route matches onboarding, forcefully close hanging notifications and exit
      if (realPageRoute == Routes.ONBOARDING) {
        if (Get.isSnackbarOpen) Snackbars.closeAll();
        return;
      }

      // Run alerts normally on all remaining application windows
      _handleSnackbar(status);
    });
  }

  void _handleSnackbar(bool status) {
    if (!status) {
      _isShowingSuccessSnackbar = false;
      Snackbars.showNetworkError(NetworkFailure().message);
    } else {
      if (_isShowingSuccessSnackbar) return;

      if (Get.isSnackbarOpen) {
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