import 'package:get/get.dart';

import 'core/network/api_client.dart';

class DependencyInjection {
  static void init() {
    Get.put(ApiClient());
  }
}
