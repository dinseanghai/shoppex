import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shoppex/dependency_injection.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import 'package:shoppex/shared/services/network_service.dart';
import 'app.dart';
import 'core/network/network_info.dart';
import 'data/local/secure_storage.dart';
import 'flavors.dart';

void main() async {
  // 1. Ensure Flutter engine bindings are fully ready
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  try {
    F.appFlavor = Flavor.values.firstWhere(
          (e) => e.name == appFlavor,
      orElse: () => Flavor.dev,
    );
  } catch (e) {
    F.appFlavor = Flavor.dev;
  }

  // 2. Keep the native splash screen locked on screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 3. Setup synchronous dependency injections
  DependencyInjection.init();

  // underlying OS stream listeners when navigating between routes.
  Get.put<Connectivity>(Connectivity(), permanent: true);
  Get.put<NetworkInfo>(NetworkInfoImpl(Get.find()), permanent: true);

  // 4. Force-instantiate and fully AWAIT the auth storage disk fetch
  // This step ensures the token is cached in memory BEFORE any routes calculate
  final authService = Get.find<AuthService>();
  await authService.initAuth();
  await SecureStorage.init();
  // 5. Initialize the global network controller background layer.
  // Pinned down safely so it functions throughout the entire app lifespan.
  Get.put(NetworkService(), permanent: true);

  // 6. Launch the app core layout
  runApp(const App());

  // 7. Dismiss splash precisely as the chosen target route initializes
  FlutterNativeSplash.remove();
}