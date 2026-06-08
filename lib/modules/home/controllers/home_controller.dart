import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../data/models/response/list_category.dart';
import '../../../data/models/response/list_slide.dart';
import '../../../data/models/response/list_store.dart';
import '../../../data/models/response/store_favorite.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';


class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var favoriteStoreIds = <int>{}.obs;
  var slideList = <SlideData>[].obs;
  var categories = <CategoryData>[].obs;
  var storeList = <Lists>[].obs;
  var currentIndex = 0.obs;

  var isLoading = false.obs;
  var notificationCount = 0.obs;
  var cartCount = 0.obs;

  // 🟢 Automatically reactive: If not authenticated, it's Guest Mode
  bool get isGuestMode => !AuthService.isAuthenticated.value;

  bool get isVendor {
    final role = AuthService.userRole.value.trim().toLowerCase();
    return role == 'vendor' || role == 'vender';
  }

  @override
  void onInit() {
    super.onInit();
    // 🟢 Use ever() to listen to authentication changes dynamically
    ever(AuthService.isAuthenticated, (_) => checkUserStatus());
    checkUserStatus();
    fetchSlideShows();
    fetchCategories();
    fetchListStore();
  }

  Future<void> fetchListStore() async {
    try {
      isLoading(true);

      // Sending an empty object or query parameters as required by your ApiClient
      final response = await _apiClient.liststore(ListStore());

      if (response.statusCode == 200 && response.data != null) {
        // 2. Parse the root response body
        final storeResponse = ListStore.fromJson(response.data);

        // 3. 🟢 Target the actual internal array: storeResponse.data.lists
        if (storeResponse.storeData != null && storeResponse.storeData?.lists != null) {
          storeList.assignAll(storeResponse.storeData!.lists!);
        }
      }
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await _apiClient.listcategory(ListCategory());

      if (response.statusCode == 200 && response.data != null) {
        // Map the JSON response to your ListCategory model
        final categoryResponse = ListCategory.fromJson(response.data);

        if (categoryResponse.categoryData != null) {
          categories.assignAll(categoryResponse.categoryData!);
        }
      } else {

      }
    } catch (e) {

    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSlideShows() async {
    try {
      isLoading(true);

      final response = await _apiClient.listslideshow(SlideShow());

      if (response.statusCode == 200 && response.data != null) {
        // Parse the response using your SlideShow model architecture
        final slideShowResponse = SlideShow.fromJson(response.data);

        if (slideShowResponse.data != null) {
          slideList.assignAll(slideShowResponse.data!);
        }
      } else {
        Get.log("⚠️ Failed to load slideshows. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      Get.log("❌ Exception caught while fetching slideshows: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void checkUserStatus() {
    if (isGuestMode) {
      notificationCount.value = 0;
      cartCount.value = 0;
    } else {
      // Fetch actual data for signed-in users here
      notificationCount.value = 1;
      cartCount.value = 3;
    }
  }

  // 🟢 This method protects your actions seamlessly
  void handleProtectedAction(VoidCallback onUserApproved) {
    if (isGuestMode) {
      Get.toNamed(Routes.SIGNIN); // Use .toNamed so they can press 'back' if they want to return to browsing as guest
    } else {
      onUserApproved();
    }
  }

  void onListStoreVisit() {
    handleProtectedAction(() {

    });
  }

  void onStoreFavoriteClick(Lists store) {
    handleProtectedAction(() async {
      final storeId = store.id;
      if (storeId == null) return;

      // Prevent double-tapping the button while a request is in mid-air
      if (favoriteStoreIds.contains(storeId)) return;

      // Save current status for a rollback if the server network call fails
      final bool originalFavState = store.isFav ?? false;

      try {
        // 1. Optimistic Update (UI changes instantly)
        store.isFav = !originalFavState;
        storeList.refresh();
        favoriteStoreIds.add(storeId);

        // 2. Network Call
        final response = await _apiClient.favonstore(storeId);

        // 3. Strongly Typed Model Validation
        if (response.statusCode == 200 && response.data != null) {

          // 🟢 Parse response data directly into your Response Model
          final favResponse = StoreFavorite.fromJson(response.data);

          if (favResponse.status == 'success' || favResponse.statusCode == 200) {
            // Sync state with what the backend explicitly returned
            store.isFav = favResponse.isFav ?? store.isFav;

            Get.snackbar(
              "Success",
              favResponse.message ?? "Store updated.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            // Backend sent an explicit failure flag inside the object body
            store.isFav = originalFavState;
            Get.snackbar("Error", favResponse.message ?? "Could not complete update.");
          }
        } else {
          // Server returned an HTTP status code other than 200 OK
          store.isFav = originalFavState;
          Get.snackbar("Error", "Could not complete update.");
        }
      } catch (e) {
        // Fallback on unexpected exceptions or network timeouts
        store.isFav = originalFavState;
        Get.log("Favorite Error: $e");
        Get.snackbar("Error", "Network connection issue.");
      } finally {
        // Always remove loading state and refresh layout lists
        favoriteStoreIds.remove(storeId);
        storeList.refresh();
      }
    });
  }

  void onListStoreClick () {
    handleProtectedAction(() {

    });
  }

  void onCategoryClick() {
    handleProtectedAction(() {

    });
  }

  void onNotificationClick() {
    handleProtectedAction(() {
      Get.snackbar("Success", "Notification Open!");
      //Get.toNamed(Routes.NOTIFICATIONS);
    });
  }

  void onCartClick() {
    handleProtectedAction(() {
      if (Get.isRegistered<MainLayoutController>()) {
        final mainLayoutController = Get.find<MainLayoutController>();

        mainLayoutController.changeTab(1);
      } else {
        //Get.toNamed(Routes.CART);
      }
    });
  }

  void onAddToFavoriteClick() {
    handleProtectedAction(() {
      // Your favorite logic here
      Get.snackbar("Success", "Added to favorites!");
    });
  }
  void seeAllCategoryClick() {
    handleProtectedAction(() {

    });
  }

  void featuredStoreClick() {
    handleProtectedAction(() {

    });
  }

  void trendingProductClick () {
    handleProtectedAction(() {

    });
  }

}