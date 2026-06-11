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
import '../../../shared/services/network_service.dart';
import '../widgets/add_favorite_bottombar.dart';


class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // 🟢 Inject NetworkService to watch network state toggles
  final NetworkService _networkService = Get.find<NetworkService>();

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

  // Automatically reactive: If not authenticated, it's Guest Mode
  bool get isGuestMode => !AuthService.isAuthenticated.value;

  bool get isVendor {
    final role = AuthService.userRole.value.trim().toLowerCase();
    return role == 'vendor' || role == 'vender';
  }

  @override
  void onInit() {
    super.onInit();
    ever(AuthService.isAuthenticated, (_) => checkUserStatus());
    checkUserStatus();
    setupHomeScrollListener();

    // 1. Initial manual data load when opening home page
    fetchAllHomeData();

    // 2. 🟢 Listen for when the app regains internet connectivity
    ever(_networkService.isOnline, (bool online) {
      if (online) {
        debugPrint("🚀 Connection restored! Re-fetching home data streams...");
        fetchAllHomeData();
      }
    });
  }

  /// 🟢 Master fetch wrapper to run everything simultaneously safely
  Future<void> fetchAllHomeData() async {
    // Stop execution if the service lists the application as offline
    if (!_networkService.isOnline.value) return;

    try {
      isLoading(true); // Single global loader active entry point
      currentPage = 1;
      lastPage = 1;

      // Execute all core endpoint calls in parallel to maximize speeds
      await Future.wait([
        _fetchSlideShowsInternal(),
        _fetchCategoriesInternal(),
        _fetchListStoreInternal(),
        _fetchProductInternal(page: 1),
      ]);
    } catch (e) {
      debugPrint("❌ Core system initialization failure: $e");
    } finally {
      isLoading(false); // Clean termination exit point
    }
  }

  void setupHomeScrollListener() {
    homeScrollController.addListener(() {
      if (isLoading.value || isMoreLoading.value) return;

      final position = homeScrollController.position;
      double maxScroll = position.maxScrollExtent;
      double currentScroll = position.pixels;

      bool isNearBottom = (maxScroll - currentScroll) <= 250;
      bool isAtAbsoluteBottom = currentScroll >= maxScroll && !position.outOfRange;

      if (isNearBottom || isAtAbsoluteBottom) {
        if (currentPage < lastPage) {
          handleProtectedAction(() {
            fetchProduct(page: currentPage + 1);
          });
        }
      }
    });
  }

  /// Public entry wrapper method for pagination scrolling
  Future<void> fetchProduct({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading(true);
      } else {
        isMoreLoading(true);
      }
      await _fetchProductInternal(page: page);
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }

  /// 🟢 Internal worker method decoupled from loading flags
  Future<void> _fetchProductInternal({int page = 1}) async {
    try {
      final response = await _apiClient.listproduct(ListProduct(page: page));

      if (response.statusCode == 200 && response.data != null) {
        final productResponse = ListProduct.fromJson(response.data);

        if (productResponse.productData != null) {
          currentPage = productResponse.productData!.currentPage ?? page;
          lastPage = productResponse.productData!.lastPage ?? 1;

          if (productResponse.productData!.lists != null) {
            if (page == 1) {
              productList.assignAll(productResponse.productData!.lists!);
            } else {
              productList.addAll(productResponse.productData!.lists!);
              productList.refresh();
            }
          }
        }
      } else {
        Get.snackbar("Error", "Failed to retrieve products");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  /// Public access wrapper method
  Future<void> fetchListStore() async {
    try {
      isLoading(true);
      await _fetchListStoreInternal();
    } finally {
      isLoading(false);
    }
  }

  /// 🟢 Internal worker method decoupled from loading flags
  Future<void> _fetchListStoreInternal() async {
    try {
      final response = await _apiClient.liststore(ListStore());

      if (response.statusCode == 200 && response.data != null) {
        final storeResponse = ListStore.fromJson(response.data);

        if (storeResponse.storeData != null && storeResponse.storeData?.lists != null) {
          storeList.assignAll(storeResponse.storeData!.lists!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching store lists: $e");
    }
  }

  /// Public access wrapper method
  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      await _fetchCategoriesInternal();
    } finally {
      isLoading(false);
    }
  }

  /// 🟢 Internal worker method decoupled from loading flags
  Future<void> _fetchCategoriesInternal() async {
    try {
      final response = await _apiClient.listcategory(ListCategory());

      if (response.statusCode == 200 && response.data != null) {
        final categoryResponse = ListCategory.fromJson(response.data);

        if (categoryResponse.categoryData != null) {
          categories.assignAll(categoryResponse.categoryData!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  /// Public access wrapper method
  Future<void> fetchSlideShows() async {
    try {
      isLoading(true);
      await _fetchSlideShowsInternal();
    } finally {
      isLoading(false);
    }
  }

  /// 🟢 Internal worker method decoupled from loading flags
  Future<void> _fetchSlideShowsInternal() async {
    try {
      final response = await _apiClient.listslideshow(SlideShow());

      if (response.statusCode == 200 && response.data != null) {
        final slideShowResponse = SlideShow.fromJson(response.data);

        if (slideShowResponse.data != null) {
          slideList.assignAll(slideShowResponse.data!);
        }
      } else {
        Get.log("⚠️ Failed to load slideshows. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      Get.log("❌ Exception caught while fetching slideshows: $e");
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
      notificationCount.value = 1;
      cartCount.value = 3;
    }
  }

  Future<void> handleProtectedAction(Function action) async {
    if (isGuestMode) {
      Get.toNamed(Routes.SIGNIN);
      return;
    }
    await action();
  }

  void onListStoreVisit() {
    handleProtectedAction(() {});
  }

  void onStoreFavoriteClick(StoreItem store) async {
    final storeId = store.id;
    if (storeId == null) return;

    await handleProtectedAction(() async {
      final bool originalFavState = store.isFav ?? false;
      final int itemIndex = storeList.indexWhere((element) => element.id == storeId);

      try {
        store.isFav = !originalFavState;
        if (itemIndex != -1) {
          storeList[itemIndex] = store;
        }

        final response = await _apiClient.favonstore(storeId);

        if (response.statusCode == 200 && response.data != null) {
          final favResponse = StoreFavorite.fromJson(response.data);

          if (favResponse.status == 'success' || favResponse.statusCode == 200) {
            store.isFav = favResponse.isFav ?? store.isFav;

            if (store.isFav == true) {
              showBottomBar(
                icon: Icons.favorite,
                isFavoriteActive: true,
                message: "Added to Favourites",
                actionText: "View Favourites",
                onActionTap: () {},
              );
            } else {
              showBottomBar(
                icon: Icons.favorite_border,
                isFavoriteActive: false,
                message: "Removed from Favourites",
                actionText: "Undo",
                onActionTap: () => onStoreFavoriteClick(store),
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

  void onProductFavoriteClick(ProductItem product) async {
    final productId = product.id;
    if (productId == null) return;

    await handleProtectedAction(() async {
      final bool originalFavState = product.isFavorite == true;
      final int itemIndex = productList.indexWhere((element) => element.id == productId);

      try {
        product.isFavorite = !originalFavState;
        if (itemIndex != -1) {
          productList[itemIndex] = product;
          productList.refresh();
        }

        final response = await _apiClient.favOnProduct(productId);

        if (response.statusCode == 200 && response.data != null) {
          final favResponse = StoreFavorite.fromJson(response.data);

          if (favResponse.status == 'success' || favResponse.statusCode == 200) {
            product.isFavorite = favResponse.isFav ?? product.isFavorite;

            if (product.isFavorite == true) {
              showBottomBar(
                icon: Icons.favorite,
                isFavoriteActive: true,
                message: "Added to Favourites",
                actionText: "View Favourites",
                onActionTap: () {},
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
            product.isFavorite = originalFavState;
            showErrorBar(favResponse.message ?? "Could not complete update.");
          }
        } else {
          product.isFavorite = originalFavState;
          showErrorBar("Could not complete update.");
        }
      } catch (e) {
        product.isFavorite = originalFavState;
        showErrorBar("Network connection issue.");
      } finally {
        if (itemIndex != -1) {
          productList[itemIndex] = product;
          productList.refresh();
        }
      }
    });
  }

  void onListStoreClick () {
    handleProtectedAction(() {});
  }

  void onCategoryClick() {
    handleProtectedAction(() {});
  }

  void onNotificationClick() {
    handleProtectedAction(() {
      Get.snackbar("Success", "Notification Open!");
    });
  }

  void onCartClick() {
    handleProtectedAction(() {
      if (Get.isRegistered<MainLayoutController>()) {
        final mainLayoutController = Get.find<MainLayoutController>();
        mainLayoutController.changeTab(1);
      }
    });
  }

  void onAddToFavoriteClick() {
    handleProtectedAction(() {
      Get.snackbar("Success", "Added to favorites!");
    });
  }

  void seeAllCategoryClick() {
    handleProtectedAction(() {});
  }

  void featuredStoreClick() {
    handleProtectedAction(() {});
  }

  void trendingProductClick () {
    handleProtectedAction(() {});
  }

  @override
  void onClose() {
    homeScrollController.dispose();
    super.onClose();
  }
}