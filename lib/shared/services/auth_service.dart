import 'package:get/get.dart';
import '../../data/local/secure_storage.dart';

class AuthService extends GetxService{
  static RxBool isAuthenticated = false.obs;
  static AuthService auth = Get.find<AuthService>();
  @override
  void onInit() {
    // TODO: implement onInit
    _checkAuth();
    super.onInit();
  }

  void _checkAuth() async {
    final token = await SecureStorage.getToken();
    if(token != null || token!.isEmpty) {
      isAuthenticated(true);
    }
  }
}