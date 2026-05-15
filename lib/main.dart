import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shoppex/dependency_injection.dart';
import 'app.dart';
import 'core/network/network_info.dart';
import 'flavors.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  try {
    F.appFlavor = Flavor.values.firstWhere(
      (e) => e.name == appFlavor,
      orElse: () => Flavor.dev,
    );
  } catch (e) {
    F.appFlavor = Flavor.dev;
  }

  DependencyInjection.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.lazyPut(() => Connectivity());
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));

  FlutterNativeSplash.remove();
  runApp(const App());
}
