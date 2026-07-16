import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/icon_animation.dart';
import '../controllers/product_detail_controller.dart';

class CreateReviewBottomSheet extends StatefulWidget {
  final Function(int rating, String comment, VoidCallback onSuccess) onSubmit;

  const CreateReviewBottomSheet({super.key, required this.onSubmit});

  @override
  State<CreateReviewBottomSheet> createState() => _CreateReviewBottomSheetState();
}

class _CreateReviewBottomSheetState extends State<CreateReviewBottomSheet> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  final ProductDetailController controller = Get.find<ProductDetailController>();

  // Track state transition
  bool _isSuccess = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating by tapping the stars.")),
      );
      return;
    }

    widget.onSubmit(
      _selectedRating,
      _commentController.text.trim(),
          () {
        setState(() {
          _isSuccess = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        // Smooth height adjustments when changing screens
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SingleChildScrollView(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              // Fade transitions between the form and success layout
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _isSuccess
                  ? _buildSuccessView(key: const ValueKey('success_view'))
                  : _buildFormView(key: const ValueKey('form_view')),
            ),
          ),
        ),
      ),
    );
  }

  // --- SCREEN B: SUCCESS SCREEN ---
  Widget _buildSuccessView({required Key key}) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action Header
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                  color: Color(0xFF3B59F6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Text(
          "Thank You!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 40),

        // Custom bouncy green icon
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF5CB85C), // Success Green
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const IconAnimation(
              icon: Icons.check_rounded,
              color: Colors.white,
              size: 56,
              duration: Duration(milliseconds: 800), // Elastic bounce pop
            ),
          ),
        ),
        const SizedBox(height: 32),

        const Center(
          child: Column(
            children: [
              Text(
                "Your review was submitted\nsuccessfully and is being processed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Thank you for sharing your thoughts!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // Action Buttons
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Route to target review tracking stream
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B59F6),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            "View Your Reviews",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),

        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See Other Recent Reviews",
                  style: TextStyle(
                    color: Color(0xFF3B59F6),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Color(0xFF3B59F6),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // --- SCREEN A: INPUT FORM SCREEN ---
  Widget _buildFormView({required Key key}) {
    return Obx(() {
      final bool isSubmitting = controller.isRatingLoading.value;

      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Color(0xFF3B59F6), fontSize: 16),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),

          const Text(
            "Create Your Review",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Rating Panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9FB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E5EA)),
            ),
            child: Column(
              children: [
                const Text(
                  "Tap a star to select",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    final isSelected = starValue <= _selectedRating;
                    return GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () {
                        setState(() {
                          _selectedRating = starValue;
                        });
                      },
                      child: Icon(
                        Icons.star_rounded,
                        size: 44,
                        color: isSelected ? Colors.orange : const Color(0xFFD1D1D6),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Input Text Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9FB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E5EA)),
            ),
            child: TextField(
              controller: _commentController,
              enabled: !isSubmitting,
              maxLines: 6,
              maxLength: 500,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Share your detailed feedback here...\n(e.g., Share details about the noise cancellation, comfort, or value...)",
                hintStyle: TextStyle(color: Colors.grey, height: 1.4),
                border: InputBorder.none,
                counterText: "",
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          ElevatedButton(
            onPressed: isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B59F6),
              disabledBackgroundColor: const Color(0xFF3B59F6).withOpacity(0.5),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              "Submit Review",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}