import 'package:get/get.dart';
import 'package:shoppex/data/models/response/list_store.dart';

import '../../home/controllers/customer_home_controller.dart';

class StoreDetailController extends GetxController {
  final double staticRating = 4.8;
  final String staticReviewCount = "(12.2k+ Reviews)";

  double get rating => staticRating;
  String get reviewCount => staticReviewCount;

  // The store model
  final Rxn<StoreItem> rxStore = Rxn<StoreItem>();

  // Explicitly reactive boolean for the Favorite state
  final RxBool isFav = false.obs;

  final RxBool isDetailsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStore();
  }

  void _initializeStore() {
    // 1. Initial lookup
    if (Get.arguments != null && Get.arguments is StoreItem) {
      rxStore.value = Get.arguments as StoreItem;
      isFav.value = rxStore.value?.isFav ?? false;
    }

    // 2. Fallback network request
    final String? storeIdStr = Get.parameters['id'];
    if (storeIdStr != null && rxStore.value == null) {
      fetchStoreDetails(storeIdStr);
    }
  }

  Future<void> fetchStoreDetails(String id) async {
    try {
      isDetailsLoading.value = true;
      final customerCtrl = Get.find<CustomerController>();
      final response = await customerCtrl.apiClient.liststore(ListStore());

      if (response.statusCode == 200 && response.data != null) {
        final result = ListStore.fromJson(response.data);
        final stores = result.storeData?.lists ?? [];
        final matchedStore = stores.firstWhereOrNull((s) => s.id.toString() == id);

        if (matchedStore != null) {
          rxStore.value = matchedStore;
          // Sync the reactive variable with the loaded data
          isFav.value = matchedStore.isFav ?? false;
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      isDetailsLoading.value = false;
    }
  }

  void toggleFavorite() {
    final store = rxStore.value;
    if (store == null) return;

    // 1. Update internal reactive state for immediate UI feedback
    isFav.value = !isFav.value;

    // 2. Update the model instance
    store.isFav = isFav.value;

    // 3. Proxy the action to your CustomerController
    Get.find<CustomerController>().onStoreFavoriteClick(store);
  }
}