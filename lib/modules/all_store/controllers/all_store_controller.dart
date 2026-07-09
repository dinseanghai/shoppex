import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/response/list_store.dart';

class AllStoreController extends GetxController {
  final apiClient = Get.find<ApiClient>();
  var storeList = <StoreItem>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  int _page = 1 ;
  int _lastPage = 1;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchAllStores();

    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        fetchMoreStores();
      }
    });
  }

  Future<void> fetchAllStores() async {
    try {
      isLoading.value = true;
      _page = 1;

      // Pass the page number directly here
      final response = await apiClient.liststore(page: _page);

      if (response.statusCode == 200 && response.data != null) {
        final result = ListStore.fromJson(response.data);
        _lastPage = result.storeData?.lastPage ?? 1;
        storeList.assignAll(result.storeData?.lists ?? []);
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreStores() async {
    if (isLoadingMore.value || _page >= _lastPage) return;

    try {
      isLoadingMore.value = true;
      _page++;

      // Pass the next page number here too
      final response = await apiClient.liststore(page: _page);

      if (response.statusCode == 200 && response.data != null) {
        final result = ListStore.fromJson(response.data);
        final newItems = result.storeData?.lists ?? [];
        storeList.addAll(newItems);
      }
    } catch (e) {
      _page--;
    } finally {
      isLoadingMore.value = false;
    }
  }


  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
