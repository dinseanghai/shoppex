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

  // Preserve the splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize synchronous dependencies
  DependencyInjection.init();
  Get.lazyPut(() => Connectivity(), fenix: true);
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()), fenix: true);

  runApp(const App());

  // Remove the splash screen right as the App widget mounts
  FlutterNativeSplash.remove();
}