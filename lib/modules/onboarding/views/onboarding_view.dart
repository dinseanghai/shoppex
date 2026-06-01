import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/onboarding_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppSizes.gapH32,

            // 1. Top Bar Section (Hidden completely on the first auto-play slide, page 0)
            Obx(() {
              if (controller.currentIndex.value == 0) {
                return AppSizes.gapH48; // Invisible matching gap spacer
              }
              return _buildTopBar();
            }),

            // 2. Centralized Content Pages
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                // Dynamic physics: If on screen 1+, activate backward lock physics
                physics: controller.currentIndex.value > 0
                    ? const LockBackwardScrollPhysics(parent: BouncingScrollPhysics())
                    : const BouncingScrollPhysics(),
                onPageChanged: controller.currentIndex,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final pageData = controller.onboardingPages[index];
                  return _buildPageTemplate(pageData, index == 0);
                },
              ),
            ),

            // 3. Bottom Action Buttons Section (Hidden on the first auto-play slide)
            Obx(() {
              if (controller.currentIndex.value == 0) {
                return const SizedBox.shrink();
              }
              return _buildBottomButton();
            }),
            AppSizes.gapH64,
          ],
        ),
      ),
    );
  }

  Widget _buildPageTemplate(OnboardingModel data, bool isFirstPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.imagePath,
            height: 250,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_outlined,
              size: 250,
              color: AppColors.textSecondary,
            ),
          ),
          isFirstPage ? const SizedBox(height: 16) : AppSizes.gapH48,
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isFirstPage ? 35 : 25,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.gapH16,
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 1. Progress Indicators
          SizedBox(
            height: 8,
            child: Row(
              children: List.generate(controller.onboardingPages.length - 1, (index) {
                return Expanded(
                  child: Obx(() {
                    bool isVisited = controller.currentIndex.value >= (index + 1);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isVisited ? const Color(0xFF3B59F6) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),

          AppSizes.gapH12, // Slightly increased spacing from progress bars

          // 2. Pure Native Skip Button (Guaranteed to align right, taking up no extra layout width)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.navigateToMainLayout(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4), // Comfortable tap target area
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Strictly constraints width to text size
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF3B59F6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFF3B59F6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CustomButton(
        text: '',
        buttontype: ButtonType.elevated,
        height: 50,
        width: double.infinity,
        onPressed: controller.nextPage,
        textWidget: Obx(() => Text(
          controller.isLastPage ? 'Get Started' : 'Next',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
    );
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
    if (value < position.pixels && position.pixels <= (position.maxScrollExtent / 3)) {
      return value - position.pixels;
    }
    return super.applyBoundaryConditions(position, value);
  }
}