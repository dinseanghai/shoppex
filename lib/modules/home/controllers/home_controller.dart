import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/shared/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/loading_widget.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var deliveryLocation = 'Toul Kork, Phnom Penh'.obs;

  void changeLocation() {
    print("Location selector tapped");
  }

  void executeSearch(String query) {
    print("Searching for: $query");
  }

  void openFilters() {
    print("Filter settings tapped");
  }


}