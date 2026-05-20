import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shoppex/dependency_injection.dart';
import 'app.dart';
import 'core/network/network_info.dart';
import 'flavors.dart';

void main() async { // 1. Ensure 'async' is here
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  try {
    F.appFlavor = Flavor.values.firstWhere(
          (e) => e.name == appFlavor,
      orElse: () => Flavor.dev,
    );
  } catch (e) {
    F.appFlavor = Flavor.dev;
  }

  // Preserve the splash screen while loading dependencies
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 2. CRITICAL: Await the dependency initialization so it reads the token FIRST
  await DependencyInjection.init();

  Get.lazyPut(() => Connectivity(), fenix: true);
  Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()), fenix: true);

  // 3. Now run the app and remove the splash screen
  runApp(const App());
  FlutterNativeSplash.remove();
}