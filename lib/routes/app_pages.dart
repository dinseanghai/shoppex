import 'package:get/get.dart';
import 'package:shoppex/routes/route_middlewares.dart';
import '../dependency_injection.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/sign_in/bindings/network_binding.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // 1. DYNAMIC INITIAL ROUTE: Evaluates authentication state instantly at bootup.
  static String get INITIAL {
    final bool isLoggedIn = DependencyInjection.isAuthenticated.value;
    return isLoggedIn ? Routes.HOME : Routes.ONBOARDING;
  }

  static final routes = [
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      // Intercepts and redirects users trying to access onboarding manually
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SignInView(),
      // Combines page-specific architecture dependencies with the reactive Network tracker
      bindings: [
        SignInBinding(),
        NetworkBinding(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      bindings: [
        SignUpBinding(),
        NetworkBinding(),
      ],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(),
        NetworkBinding(), // Safely initiates background network streams directly from the home screen
      ],
      middlewares: [AuthMiddleware()],
    ),
  ];
}
