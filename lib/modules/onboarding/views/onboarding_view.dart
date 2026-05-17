import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/core/constants/app_size.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/onboarding_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';


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

            // 1. Top Bar Section (Hidden on the first auto-play slide)
            Obx(() {
              if (controller.currentIndex.value == 0) {
                return AppSizes.gapH48; // Invisible matching gap spacer
              }
              return _buildTopBar();
            }),

            // 2. Centralized Content Pages
            Expanded(
              child: Obx(() {
                return PageView.builder(
                  controller: controller.pageController,
                  // Dynamic physics: If on screen 2+, activate backward lock physics
                  physics: controller.currentIndex.value > 0
                      ? const LockBackwardScrollPhysics(parent: BouncingScrollPhysics())
                      : const BouncingScrollPhysics(),
                  onPageChanged: controller.currentIndex,
                  itemCount: controller.onboardingPages.length,
                  itemBuilder: (context, index) {
                    final pageData = controller.onboardingPages[index];
                    return _buildPageTemplate(pageData, index == 0);
                  },
                );
              }),
            ),

            // 3. Bottom Action Buttons Section (Hidden on the first auto-play slide)
            Obx(() {
              if (controller.currentIndex.value == 0) {
                // Replaced the dot with an empty widget that takes up no layout space
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
          // Using a placeholder icon if assets are missing during test
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

          // --- CHANGED HERE ---
          // Reduces or removes the gap specifically for the first page
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
      // Reduced horizontal padding slightly so the skip button aligns nicely on the right
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Aligns the Skip button to the right side
        children: [
          // 1. Progress Indicators (Takes full width now)
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

          AppSizes.gapH4, // Space between progress bars and Skip button

          // 2. Skip Button
          CustomButton(
            text: '',
            buttontype: ButtonType.text,
            // Change this line to use an explicit anonymous function:
            onPressed: () => controller.goToSignIn(),
            textWidget: const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(color: Color(0xFF3B59F6), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: Color(0xFF3B59F6)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: CustomButton(
        text: '', // Left blank because we are passing a dynamic textWidget instead
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