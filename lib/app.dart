import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/routes/app_pages.dart';
import 'package:shoppex/shared/services/network_service.dart';
import 'flavors.dart';
import 'localization/app_translations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: F.title,
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'UK'),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();

        final contentWithBanner = _flavorBanner(
          child: content,
          show: F.appFlavor == Flavor.dev,
        );

        return Stack(
          children: [
            Positioned.fill(child: contentWithBanner),

            // INTERACTION SHIELD GATE
            Obx(() {
              final networkService = Get.find<NetworkService>();
              final isOffline = !networkService.isOnline.value;

              // 1. Find the actual active page route route securely
              String currentRoute = Get.currentRoute;
              if (currentRoute.contains('rawSnackbar') || Get.isSnackbarOpen) {
                currentRoute = Get.previousRoute;
              }

              // 2. SKIP INTERACTION LOCK FOR ONBOARDING:
              // If the user is offline, but on onboarding, do not mount the touch shield.
              if (currentRoute == Routes.ONBOARDING) {
                return const SizedBox.shrink();
              }

              if (!isOffline) return const SizedBox.shrink();

              return Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
    location: BannerLocation.topStart,
    message: F.name,
    color: Colors.green.withAlpha(150),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
      letterSpacing: 1.0,
    ),
    textDirection: TextDirection.ltr,
    child: child,
  )
      : SizedBox(child: child);
}