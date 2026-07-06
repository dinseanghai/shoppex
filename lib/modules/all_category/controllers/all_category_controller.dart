import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/response/list_category.dart';

class AllCategoryController extends GetxController {
  var selectedCategoryName = ''.obs;
  final ApiClient apiClient = Get.find<ApiClient>();

  var categories = <CategoryData>[].obs;
  var isLoading = false.obs;

  final Map<String, List<String>> subCategoryMap = {
    'Electronics': ['Mobiles & Tablets', 'Computers & Laptops', 'Audio & Headphones', 'Cameras', 'Smart Home', 'Gaming'],
    'Fashion': ['Men\'s Wear', 'Women\'s Wear', 'Kids', 'Accessories', 'Bags', 'Shoes'],
    'Home & Living': ['Kitchenware', 'Furniture', 'Decor', 'Bedding', 'Lighting'],
  };

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await apiClient.listcategory(ListCategory());

      if (response.statusCode == 200 && response.data != null) {
        final result = ListCategory.fromJson(response.data);
        categories.assignAll(result.categoryData ?? []);

        if (categories.isNotEmpty) {
          selectedCategoryName.value = categories.first.name ?? '';
        }
      } else {
        print("DEBUG: Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("DEBUG: CATCH BLOCK ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String name) {
    // Use .trim() to ensure hidden spaces from the API don't break string equality
    selectedCategoryName.value = name.trim();

    // Forces the reactive UI to rebuild manually in case GetX misses the update
    categories.refresh();
  }

}
