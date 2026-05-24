import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/routes/app_pages.dart';
import 'package:shoppex/shared/services/network_overlay.dart';
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

      // CLEANED: routingCallback completely removed from this layout context

      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();

        final contentWithBanner = _flavorBanner(
          child: content,
          show: F.appFlavor == Flavor.dev,
        );

        return NetworkOverlay(child: contentWithBanner);
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