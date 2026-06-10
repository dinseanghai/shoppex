import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../data/models/response/list_category.dart';
import '../../../data/models/response/list_product.dart';
import '../../../data/models/response/list_slide.dart';
import '../../../data/models/response/list_store.dart';
import '../../../data/models/response/store_favorite.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../widgets/add_favorite_bottombar.dart';


class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final ScrollController homeScrollController = ScrollController();
  var favoriteStoreIds = <int>[].obs;
  var favoriteProductIds = <int>[].obs;
  var slideList = <SlideData>[].obs;
  var categories = <CategoryData>[].obs;
  var storeList = <StoreItem>[].obs;
  var productList = <ProductItem>[].obs;
  var currentIndex = 0.obs;

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  int currentPage = 1;
  int lastPage = 1;

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
    setupHomeScrollListener();
    fetchSlideShows();
    fetchCategories();
    fetchListStore();
    fetchProduct(page: 1);
  }

  void setupHomeScrollListener() {
    homeScrollController.addListener(() {
      double maxScroll = homeScrollController.position.maxScrollExtent;
      double currentScroll = homeScrollController.position.pixels;

      // 💡 Check your running debug console to see this text dynamically update!
      debugPrint("Screen Moving -> Position: ${currentScroll.toInt()} / Max: ${maxScroll.toInt()}");

      // Triggers when you are within 200 logical pixels of the bottom border
      if (maxScroll - currentScroll <= 200) {
        if (!isLoading.value && !isMoreLoading.value && currentPage < lastPage) {

          debugPrint("🟢 Bottom Hit! Running pagination for page: ${currentPage + 1}");

          handleProtectedAction(() {
            fetchProduct(page: currentPage + 1);
          });

        }
      }
    });
  }

  Future<void> fetchProduct({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading(true);
      } else {
        isMoreLoading(true);
      }

      // 🟢 Pass the initialized ListProduct configuration straight to ApiClient
      final response = await _apiClient.listproduct(ListProduct(page: page));

      if (response.statusCode == 200 && response.data != null) {
        final productResponse = ListProduct.fromJson(response.data);

        if (productResponse.productData != null) {
          // Explicitly fallback increment instead of overriding hard entries
          currentPage = productResponse.productData!.currentPage ?? page;
          lastPage = productResponse.productData!.lastPage ?? 1; // Safely default map to 1 if null

          if (productResponse.productData!.lists != null) {
            if (page == 1) {
              productList.assignAll(productResponse.productData!.lists!);
            } else {
              productList.addAll(productResponse.productData!.lists!);
              productList.refresh(); // Tells GetX lists to layout new slots
            }
          }
        }
      } else {
        Get.snackbar("Error", "Failed to retrieve products");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
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

  void onStoreFavoriteClick(StoreItem store) {
    final storeId = store.id;
    if (storeId == null) return;

    handleProtectedAction(() async {
      final bool originalFavState = store.isFav ?? false;
      final int itemIndex = storeList.indexWhere((element) => element.id == storeId);

      try {
        // 1. Instant Optimistic Update
        store.isFav = !originalFavState;
        if (itemIndex != -1) {
          storeList[itemIndex] = store;
        }

        // 2. Network Request
        final response = await _apiClient.favonstore(storeId);

        // 3. Validate Response Payload
        if (response.statusCode == 200 && response.data != null) {
          final favResponse = StoreFavorite.fromJson(response.data);

          if (favResponse.status == 'success' || favResponse.statusCode == 200) {
            store.isFav = favResponse.isFav ?? store.isFav;

            // 🟢 4. Show customized Neo-Glass design matching your style requirements
            if (store.isFav == true) {
              // Image 1: Saved
              showBottomBar(
                icon: Icons.favorite,
                isFavoriteActive: true,
                message: "Add to Favourites",
                actionText: "View Favourites",
                onActionTap: () {
                  // Get.toNamed(Routes.FAVOURITES);
                },
              );
            } else {
              // Image 2: Removed from Favourites
              showBottomBar(
                icon: Icons.favorite_border,
                isFavoriteActive: false,
                message: "Removed from Favourites",
                actionText: "Undo",
                onActionTap: () {
                  onStoreFavoriteClick(store); // Recursively undo toggle
                },
              );
            }

          } else {
            store.isFav = originalFavState;
            showErrorBar(favResponse.message ?? "Could not complete update.");
          }
        } else {
          store.isFav = originalFavState;
          showErrorBar("Could not complete update.");
        }
      } catch (e) {
        store.isFav = originalFavState;
        showErrorBar("Network connection issue.");
      } finally {
        if (itemIndex != -1) {
          storeList[itemIndex] = store;
        }
      }
    });
  }

  void onProductFavoriteClick(ProductItem product) {
    final productId = product.id;
    if (productId == null) return;

    handleProtectedAction(() async {
      final bool originalFavState = product.isFavorite == true;
      final int itemIndex = productList.indexWhere((element) => element.id == productId);

      try {
        // 1. Instant Optimistic Update (Happens immediately)
        product.isFavorite = !originalFavState;
        if (itemIndex != -1) {
          productList[itemIndex] = product;
          productList.refresh(); // Forces GetX grid to instantly paint the new heart color
        }

        // 2. Network Request
        final response = await _apiClient.favOnProduct(productId);

        // 3. Validate Response Payload
        if (response.statusCode == 200 && response.data != null) {
          final favResponse = StoreFavorite.fromJson(response.data);

          if (favResponse.status == 'success' || favResponse.statusCode == 200) {
            product.isFavorite = favResponse.isFav ?? product.isFavorite;

            // 4. Show Custom Neo-Glass Bottom Bars
            if (product.isFavorite == true) {
              showBottomBar(
                icon: Icons.favorite,
                isFavoriteActive: true,
                message: "Added to Favourites",
                actionText: "View Favourites",
                onActionTap: () {
                  // Get.toNamed(Routes.FAVOURITES);
                },
              );
            } else {
              showBottomBar(
                icon: Icons.favorite_border,
                isFavoriteActive: false,
                message: "Removed from Favourites",
                actionText: "Undo",
                onActionTap: () => onProductFavoriteClick(product),
              );
            }
          } else {
            // Revert if backend error
            product.isFavorite = originalFavState;
            showErrorBar(favResponse.message ?? "Could not complete update.");
          }
        } else {
          product.isFavorite = originalFavState;
          showErrorBar("Could not complete update.");
        }
      } catch (e) {
        // Revert if network connection drops
        product.isFavorite = originalFavState;
        showErrorBar("Network connection issue.");
      } finally {
        // 5. Ensure UI syncs perfectly on completion or fallback revert
        if (itemIndex != -1) {
          productList[itemIndex] = product;
          productList.refresh();
        }
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

  @override
  void onClose() {
    // TODO: implement onClose
    homeScrollController.dispose();
    super.onClose();
  }

}