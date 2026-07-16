import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/data/models/response/list_store.dart';
import '../../home/controllers/customer_home_controller.dart';

class StoreDetailController extends GetxController {
  var isPhoneClicked = false.obs;
  var isEmailClicked = false.obs;
  // The reactive store model frame
  final Rxn<StoreItem> rxStore = Rxn<StoreItem>();

  // Explicitly reactive boolean for the Favorite state heart icon
  final RxBool isFav = false.obs;

  // Computed properties extracted straight from the live reactive store model
  double get ratingsAvg => (rxStore.value?.ratingsAvg ?? rxStore.value?.rating?.star ?? 0.0).toDouble();
  int get ratingsCount => rxStore.value?.ratingsCount ?? rxStore.value?.rating?.count ?? 0;

  @override
  void onInit() {
    super.onInit();
    _initializeStore();
  }

  void _initializeStore() {
    // 1. Handle full StoreItem object passed down
    if (Get.arguments != null && Get.arguments is StoreItem) {
      final StoreItem store = Get.arguments as StoreItem;
      rxStore.value = store;
      isFav.value = store.isFav.value;

      if (rxStore.value?.id != null) {
        _fetchBackgroundDetails(rxStore.value!.id!);
      }
    }
    // 2. Fallback: If only the ID was passed as an argument (int or String)
    else if (Get.arguments != null && (Get.arguments is int || Get.arguments is String)) {
      _fetchBackgroundDetails(Get.arguments);
    }
    // 3. Optional Fallback: If passed via URL parameter like /store-detail/:id
    else if (Get.parameters['id'] != null) {
      _fetchBackgroundDetails(Get.parameters['id']);
    }
  }

  // Core Background Network Synchronizer
  Future<void> _fetchBackgroundDetails(dynamic storeId) async {
    try {

      // Look up your ApiClient inside GetX and trigger your new endpoint method
      final customerCtrl = Get.find<CustomerController>();
      final response = await customerCtrl.apiClient.storeDetail(storeId.toString());

      if (response.statusCode == 200 && response.data != null) {
        final result = DetailStore.fromJson(response.data);

        if (result.storeData != null) {
          final freshData = result.storeData!;

          // If rxStore was never initialized because we only passed an ID, initialize it here
          if (rxStore.value == null) {
            rxStore.value = freshData; // assuming freshData is a StoreItem type, or map it accordingly
            isFav.value = freshData.isFav.value;
          } else {
            // Safely update existing memory structure
            rxStore.update((val) {
              val?.activatedAt = freshData.activatedAt;
              val?.ratingsAvg = freshData.ratingsAvg;
              val?.ratingsCount = freshData.ratingsCount;
              val?.productCount = freshData.productCount;
              val?.products = freshData.products;
              val?.myRating = freshData.myRating;
            });
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Background data sync crashed!");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $stackTrace");
    }
  }

  // Calculates store lifetime completely client-side without flickering
  String get storeLifetime {
    final String? activatedAtStr = rxStore.value?.activatedAt;

    // While background network fetch hasn't arrived, show an elegant static text indicator
    if (activatedAtStr == null) return "...";

    try {
      final DateTime activationDate = DateTime.parse(activatedAtStr);
      final DateTime now = DateTime.now();

      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime activeDay = DateTime(activationDate.year, activationDate.month, activationDate.day);
      final int dayDifference = today.difference(activeDay).inDays;

      if (dayDifference >= 365) {
        final int years = (dayDifference / 365).floor();
        return "Active for $years ${years == 1 ? 'year' : 'years'}";
      } else if (dayDifference >= 30) {
        final int months = (dayDifference / 30).floor();
        return "Active for $months ${months == 1 ? 'month' : 'months'}";
      } else if (dayDifference > 0) {
        return "Active for $dayDifference ${dayDifference == 1 ? 'day' : 'days'}";
      } else {
        return "Joined today";
      }
    } catch (e) {
      return "Active Partner";
    }
  }

  void toggleFavorite() {
    final store = rxStore.value;
    if (store == null) return;

    // 1. Toggle local reactive state
    isFav.value = !isFav.value;

    // 2. Assign the bool value to the .value property of the RxBool in your model
    store.isFav.value = isFav.value;

    // 3. Delegate to the controller
    Get.find<CustomerController>().onStoreFavoriteClick(store);
  }

}