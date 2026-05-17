import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_assets.dart';
import 'package:shoppex/core/constants/app_string.dart';
import '../../../data/models/onboarding_model.dart';
import '../../../routes/app_pages.dart';


class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentIndex = 0.obs;

  bool get isLastPage => currentIndex.value == onboardingPages.length - 1;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      imagePath: AppAssets.onboarding_1,
      title: AppStrings.onboarding_1_title,
      description: AppStrings.onboarding_1_dec,
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding_2,
      title: AppStrings.onboarding_2_title,
      description: AppStrings.onboarding_2_dec,
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding_3,
      title: AppStrings.onboarding_3_title,
      description: AppStrings.onboarding_3_dec,
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding_4,
      title: AppStrings.onboarding_4_title,
      description: AppStrings.onboarding_4_dec,
    ),
  ];

  @override
  void onReady() {
    super.onReady();
    _startInitialAutoTransition();
  }

  void _startInitialAutoTransition() {
    Future.delayed(const Duration(seconds: 4), () {
      if (currentIndex.value == 0) {
        pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void nextPage() {
    if (isLastPage) {
      goToSignIn();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToSignIn() {
    Get.offAllNamed(Routes.SIGNIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

/// Custom ScrollPhysics that locks backward swiping only when on or past page 1.
class LockBackwardScrollPhysics extends ScrollPhysics {
  const LockBackwardScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  LockBackwardScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return LockBackwardScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // value < position.pixels means the user is trying to scroll backwards (left-to-right swipe)
    // position.pixels <= position.maxScrollExtent / (pagesCount - 1) * 1 checking if we are past page 0 boundary
    if (value < position.pixels && position.pixels <= (position.maxScrollExtent / 3)) {
      return value - position.pixels; // Block the overscroll movement backwards to page 0
    }
    return super.applyBoundaryConditions(position, value);
  }
}