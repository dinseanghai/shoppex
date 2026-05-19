import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import 'core/network/api_client.dart';
import 'data/local/secure_storage.dart';

class DependencyInjection {
  static void init() {
    Get.put(ApiClient());
    Get.put(SecureStorage());
    Get.put(AuthService());
  }
}
