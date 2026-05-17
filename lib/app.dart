import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/routes/app_pages.dart';
import 'flavors.dart';
import 'localization/app_translations.dart';
import 'modules/home/views/home_view.dart';
import 'modules/onboarding/controllers/onboarding_controller.dart';
import 'modules/onboarding/views/onboarding_view.dart';


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

      // 1. Define the initial route string instead of using 'home'
      initialRoute: Routes.ONBOARDING,

      getPages: [
        // 2. Map the Onboarding Route and attach its controller binding
        GetPage(
          name: Routes.ONBOARDING,
          page: () => _flavorBanner(child: const OnboardingView(), show: kDebugMode),
          binding: BindingsBuilder(() {
            Get.lazyPut<OnboardingController>(() => OnboardingController());
          }),
        ),
        // 3. Map the Home Route
        GetPage(
          name: Routes.HOME,
          page: () => _flavorBanner(child: const HomeView(), show: kDebugMode),
        ),
      ],
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          textDirection: TextDirection.ltr,
          child: child,
        )
      : Container(child: child);
}
