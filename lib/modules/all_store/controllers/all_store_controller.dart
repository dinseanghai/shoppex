import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/response/list_store.dart';

class AllStoreController extends GetxController {
  final apiClient = Get.find<ApiClient>();
  var storeList = <StoreItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStores();
  }

  Future<void> fetchAllStores() async {
    try {
      isLoading.value = true;
      final response = await apiClient.liststore(ListStore());
      if (response.statusCode == 200 && response.data != null) {
        final result = ListStore.fromJson(response.data);
        storeList.assignAll(result.storeData?.lists ?? []);
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
