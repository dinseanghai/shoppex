import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/response/list_category.dart';
import '../../../data/models/response/list_product.dart';
import '../../../data/models/response/list_slide.dart';
import '../../../data/models/response/list_store.dart';
import '../../../data/models/response/product_favorite.dart';
import '../../../data/models/response/store_favorite.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/services/auth_service.dart';
import '../widgets/add_favorite_bottombar.dart';
import 'base_home_controller.dart';

class CustomerController extends BaseHomeController {
  final ScrollController homeScrollController = ScrollController();

  // ======================================================
  // DATA
  // ======================================================
  final slideList = <SlideData>[].obs;
  final categories = <CategoryData>[].obs;
  final storeList = <StoreItem>[].obs;
  final productList = <ProductItem>[].obs;

  final currentIndex = 0.obs;
  final notificationCount = 0.obs;
  final cartCount = 0.obs;

  final isLoading = false.obs;
  final isMoreLoading = false.obs;

  // ======================================================
  // PAGINATION
  // ======================================================
  int currentPage = 1;
  int lastPage = 1;

  // ======================================================
  // LIFECYCLE
  // ======================================================
  @override
  void onInit() {
    super.onInit();

    // 1. Only fetch if we have no data
    if (productList.isEmpty) {
      fetchHomeData();
    }

    ever(AuthService.isAuthenticated, (bool isAuthenticated) {
      // 2. DO NOT call resetPagination() here.
      // Instead, just perform a silent refresh or fetch only if needed.
      // If you MUST refresh, don't clear the list first.
      fetchHomeData();
    });
  }

  @override
  void onReady() {
    super.onReady();
    homeScrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    homeScrollController.removeListener(_scrollListener);
    homeScrollController.dispose();
    super.onClose();
  }

  // ======================================================
  // HOME DATA
  // ======================================================
  Future<void> fetchHomeData() async {
    if (!networkService.isOnline.value || isLoading.value) return;

    try {
      isLoading.value = true;

      currentPage = 1;
      lastPage = 1;

      productList.clear();

      await Future.wait([
        fetchSlideShows(),
        fetchCategories(),
        fetchStores(),
        fetchProducts(page: 1),
      ]);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (homeScrollController.hasClients) {
          homeScrollController.jumpTo(0);
        }
        _checkAutoLoad();
      });
    } catch (e) {
      debugPrint('fetchHomeData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // PAGINATION
  // ======================================================
  void _scrollListener() {
    if (!homeScrollController.hasClients) return;

    final position = homeScrollController.position;

    final isNearBottom =
        position.pixels >= position.maxScrollExtent - 300;

    if (!isNearBottom) return;

    if (isLoading.value || isMoreLoading.value) return;

    if (currentPage >= lastPage) return;

    fetchProducts(page: currentPage + 1);
  }

  void _checkAutoLoad() {
    if (!homeScrollController.hasClients) return;

    final position = homeScrollController.position;

    if (position.maxScrollExtent <= position.viewportDimension) {
      if (!isLoading.value &&
          !isMoreLoading.value &&
          currentPage < lastPage) {
        fetchProducts(page: currentPage + 1);
      }
    }
  }

  void resetPagination() {
    currentPage = 1;
    lastPage = 1;
    productList.clear();
    isLoading.value = false;
    isMoreLoading.value = false;
  }

  // ======================================================
  // API - SLIDES / CATEGORY / STORE / PRODUCT
  // ======================================================
  Future<void> fetchSlideShows() async {
    try {
      final response = await apiClient.listslideshow(SlideShow());
      if (response.statusCode == 200 && response.data != null) {
        final result = SlideShow.fromJson(response.data);
        slideList.assignAll(result.data ?? []);
      }
    } catch (_) {}
  }

  Future<void> fetchCategories() async {
    try {
      final response = await apiClient.listcategory(ListCategory());
      if (response.statusCode == 200 && response.data != null) {
        final result = ListCategory.fromJson(response.data);
        categories.assignAll(result.categoryData ?? []);
      }
    } catch (_) {}
  }

  Future<void> fetchStores() async {
    try {
      final response = await apiClient.liststore(ListStore());
      if (response.statusCode == 200 && response.data != null) {
        final result = ListStore.fromJson(response.data);
        storeList.assignAll(result.storeData?.lists ?? []);
      }
    } catch (_) {}
  }

  Future<void> fetchProducts({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await apiClient.listproduct(
        ListProduct(page: page),
      );

      if (response.statusCode == 200 && response.data != null) {
        final result = ListProduct.fromJson(response.data);

        final newProducts = result.productData?.lists ?? [];

        currentPage = result.productData?.currentPage ?? page;
        lastPage = result.productData?.lastPage ?? 1;

        if (page == 1) {
          productList.assignAll(newProducts);
        } else {
          productList.addAll(newProducts);
        }

        productList.refresh();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkAutoLoad();
        });
      }
    } catch (e) {
      debugPrint('fetchProducts error: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  // ======================================================
  // FAVORITES (STORE)
  // ======================================================
  Future<void> onStoreFavoriteClick(StoreItem store) async {
    final storeId = store.id;
    if (storeId == null) return;

    await requireLogin(() async {
      final original = store.isFav ?? false;
      final index = storeList.indexWhere((e) => e.id == storeId);

      try {
        store.isFav = !original;

        if (index != -1) {
          storeList[index] = store;
          storeList.refresh();
        }

        final response = await apiClient.favonstore(storeId);

        if (response.statusCode == 200 && response.data != null) {
          final result = StoreFavorite.fromJson(response.data);
          store.isFav = result.isFav ?? !original;
        } else {
          store.isFav = original;
        }

        final isFav = store.isFav ?? false;

        showBottomBar(
          icon: isFav ? Icons.favorite : Icons.favorite_border,
          isFavoriteActive: isFav,
          message: isFav
              ? "Added to Favourites"
              : "Removed from Favourites",
          actionText: isFav ? "View Favourites" : "Undo",
          onActionTap: () => onStoreFavoriteClick(store),
        );
      } catch (_) {
        store.isFav = original;
        showErrorBar('Network error');
      } finally {
        if (index != -1) {
          storeList[index] = store;
          storeList.refresh();
        }
      }
    });
  }

  // ======================================================
  // FAVORITES (PRODUCT)
  // ======================================================
  Future<void> onProductFavoriteClick(ProductItem product) async {
    final productId = product.id;
    if (productId == null) return;

    await requireLogin(() async {
      final original = product.isFavorite == true;
      final index = productList.indexWhere((e) => e.id == productId);

      try {
        product.isFavorite = !original;

        if (index != -1) {
          productList[index] = product;
          productList.refresh();
        }

        final response = await apiClient.favOnProduct(productId);

        if (response.statusCode == 200 && response.data != null) {
          final result = ProductFavorite.fromJson(response.data);
          product.isFavorite = result.isFavorite ?? !original;
        } else {
          product.isFavorite = original;
        }

        final isFav = product.isFavorite ?? false;

        showBottomBar(
          icon: isFav ? Icons.favorite : Icons.favorite_border,
          isFavoriteActive: isFav,
          message: isFav
              ? "Added to Favourites"
              : "Removed from Favourites",
          actionText: isFav ? "View Favourites" : "Undo",
          onActionTap: () => onProductFavoriteClick(product),
        );
      } catch (_) {
        product.isFavorite = original;
        showErrorBar('Network error');
      } finally {
        if (index != -1) {
          productList[index] = product;
          productList.refresh();
        }
      }
    });
  }

  // ======================================================
  // UI EVENTS
  // ======================================================
  void updateIndex(int index) => currentIndex.value = index;

  void onNotificationClick() {
    requireLogin(() async {
      Get.snackbar('Success', 'Notification Open!');
    });
  }

  void onCartClick() {
    requireLogin(() async {
      if (Get.isRegistered<MainLayoutController>()) {
        Get.find<MainLayoutController>().changeTab(1);
      }
    });
  }

  void onProductClick(ProductItem product) {
    requireLogin(() async {
      Get.toNamed(
        '${Routes.PRODUCT_DETAIL}/${product.id}',
        arguments: product,
      );
    });
  }

  void seeAllCategoryClick() {}
  void featuredStoreClick() {}
  void trendingProductClick() {}
}