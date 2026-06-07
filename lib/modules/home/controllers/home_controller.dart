import 'dart:ui';
import 'package:get/get.dart';
import 'package:shoppex/core/network/api_client.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../data/models/response/list_category.dart';
import '../../../data/models/response/list_slide.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';


class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var slideList = <SlideData>[].obs;
  var categories = <Data>[].obs;
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
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await _apiClient.listcategory(ListCategory());

      if (response.statusCode == 200 && response.data != null) {
        // Map the JSON response to your ListCategory model
        final categoryResponse = ListCategory.fromJson(response.data);

        if (categoryResponse.data != null) {
          categories.assignAll(categoryResponse.data!);
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

}