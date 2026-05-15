import 'package:shoppex/core/config/app_config.dart';

class ApiEndpoints {
  static String get login => '${AppConfig.baseUrl}/api/v1/auth/login';
  static String get register => '${AppConfig.baseUrl}/api/v1/auth/register';
}