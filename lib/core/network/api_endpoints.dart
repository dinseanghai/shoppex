import 'package:shoppex/core/config/app_config.dart';

class ApiEndpoints {
  static String get login => '${AppConfig.baseUrl}/api/v1/auth/login';
  static String get register => '${AppConfig.baseUrl}/api/v1/auth/register';
  static String get logout => '${AppConfig.baseUrl}/api/v1/auth/logout';
  static String get otp => '${AppConfig.baseUrl}/api/v1/auth/verify-otp';
  static String get resendotp => '${AppConfig.baseUrl}/api/v1/auth/resend-otp';
  static String get forgetpassword  => '${AppConfig.baseUrl}/api/v1/auth/forgot-password';
  static String get resetpassword => '${AppConfig.baseUrl}/api/v1/auth/reset-password';
  static String get listslideshow => '${AppConfig.baseUrl}/api/v1/slide-shows';
  static String get listcategory => '${AppConfig.baseUrl}/api/v1/categories';
}