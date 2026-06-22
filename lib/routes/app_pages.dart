import 'package:get/get.dart';
import 'package:shoppex/modules/account/controllers/base_account_controller.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/controllers/customer_account_controller.dart';
import '../modules/account/views/account_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/controllers/base_home_controller.dart';
import '../modules/home/controllers/customer_home_controller.dart';
import '../modules/home/controllers/vender_home_controller.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/otp_resetpassword/bindings/otp_resetpassword_binding.dart';
import '../modules/otp_resetpassword/views/otp_resetpassword_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../shared/layouts/main_layout.dart';
import 'route_middlewares.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.MAIN_LAYOUT,
      page: () => const MainLayout(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BaseHomeController());
        Get.lazyPut(() => CustomerController()); // ✅ ADD THIS
        Get.lazyPut(() => VenderController());   // optional (future use)
        Get.lazyPut(() => BaseAccountController());
        Get.lazyPut(() => MainLayoutController());
      }),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SignInView(),
      binding: SignInBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpVerificationView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_RESETPASSWORD,
      page: () => const OtpResetpasswordView(),
      binding: OtpResetpasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
  ];
}
