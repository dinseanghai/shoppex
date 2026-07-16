import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product_description_tile.dart';
import '../widgets/rating.dart';
import '../widgets/review_bottomsheet.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isDetailsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF3B59F6)),
          );
        }

        final product = controller.rxProduct.value;

        if (product == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text("Product data unavailable", style: TextStyle(fontSize: 15, color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B59F6)),
                  child: const Text("Go Back", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          );
        }

        final List<dynamic> productImages = product.images ?? [];

        return Stack(
          children: [
            // ======================================================
            // LAYER 1: Scrollable Body Layout Content
            // ======================================================
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Banner Showcase Section
                    Stack(
                      children: [
                        Container(
                          height: 380,
                          width: double.infinity,
                          color: const Color(0xFFEBEBEB),
                          child: productImages.isNotEmpty
                              ? Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              PageView.builder(
                                controller: controller.imagePageController,
                                itemCount: productImages.length,
                                // The user can still slide if there's > 1 image, but if it's 1 it won't move anyway
                                physics: productImages.length > 1
                                    ? const BouncingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                onPageChanged: (index) {
                                  controller.currentImageIndex.value = index;
                                },
                                itemBuilder: (context, index) {
                                  final imageUrl = productImages[index].path ?? '';
                                  return Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: Color(0xFF3B59F6),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFF5F5F5),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text(
                                              "Image unavailable",
                                              style: TextStyle(color: Colors.grey, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                              // 2. Dynamic Sliding Dots Indicator (Only shows if there are multiple images)
                              if (productImages.length > 1)
                                Positioned(
                                  bottom: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(productImages.length, (index) {
                                      bool isActive = index == controller.currentImageIndex.value;
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        height: 6,
                                        width: isActive ? 20 : 6,
                                        decoration: BoxDecoration(
                                          color: isActive ? const Color(0xFF3B59F6) : Colors.white.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          )
                              : const Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                        // Discount Badge overlay
                        if ((product.discountPercent ?? 0) > 0)
                          Positioned(
                            top: statusBarHeight + 64,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6D00),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discountPercent}% OFF',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Title
                          Text(
                            product.name ?? '',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black, height: 1.3),
                          ),
                          const SizedBox(height: 8),

                          // Price Configuration Row Element Blocks
                          Row(
                            children: [
                              Text(
                                '\$${product.salePrice ?? ''}',
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF3B59F6)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${product.basePrice ?? ''}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                              ),
                              const SizedBox(width: 10),
                              Obx(() {
                                final savingsText = controller.discountSaving;
                                if (savingsText == null) return const SizedBox.shrink();

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    savingsText,
                                    style: const TextStyle(
                                      color: Color(0xFFFF6D00),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Dynamic Seller and Ratings Banner Line
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              // Safe check fallback for empty rating strings
                              Text(
                                product.ratingAvg?.toString() ?? '0.0',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.ratingCount ?? 0})',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(width: 16),

                              // Safely check if the store is present before rendering the store chip
                              if (product.store != null)
                                GestureDetector(
                                  onTap: () {
                                    final storeId = product.store?.id;
                                    if (storeId != null) {
                                      // Generates the absolute, non-ambiguous path parameter GetX expects
                                      Get.toNamed('/store-detail/$storeId');
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F4FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // Keep the row compact
                                      children: [
                                        // Safe access with ?. instead of !.
                                        if (product.store?.logo != null)
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundImage: NetworkImage(product.store!.logo!),
                                          )
                                        else
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: const Color(0xFF3B59F6),
                                            child: Text(
                                              (product.store?.name?.isNotEmpty == true)
                                                  ? product.store!.name!.substring(0, 1).toUpperCase()
                                                  : 'S',
                                              style: const TextStyle(fontSize: 8, color: Colors.white),
                                            ),
                                          ),
                                        const SizedBox(width: 6),
                                        Text(
                                          product.store?.name ?? 'Store',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (product.store?.isVerified == true) ...[
                                          const SizedBox(width: 4),
                                          const Icon(Icons.verified_outlined, size: 14, color: Color(0xFF3B59F6)),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Divider(height: 32, color: Color(0xFFF5F5F5)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(24)),
                                    child: Row(
                                      children: [
                                        IconButton(icon: const Icon(Icons.remove, size: 14), onPressed: () => controller.decrementQuantity()),
                                        Obx(() => Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text('${controller.quantity.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        )),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 14),
                                          onPressed: () => controller.incrementQuantity(),
                                          style: IconButton.styleFrom(
                                            backgroundColor: const Color(0xFF3B59F6),
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(24, 24),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  const Text("In Stock", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 40, color: Color(0xFFF5F5F5)),

                          // Inside your screen's build method:
                          Obx(() {
                            // 1. If the API is still downloading the full product details, show a placeholder/loader
                            if (controller.isDetailsLoading.value) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: CircularProgressIndicator.adaptive()),
                              );
                            }

                            // 2. Safely grab the product once it loaded
                            final product = controller.rxProduct.value;

                            // 3. Pass the fresh data straight to your custom tile
                            return ProductDescriptionTile(
                              shortDesc: product?.shortDescription, // Or whatever property you map to shortDesc
                              description: product?.description,
                            );
                          }),
                          const Divider(height: 40, color: Color(0xFFF5F5F5)),

                          Obx(() {
                            return Review(
                              ratingsAvg: controller.averageRating,
                              ratingsCount: controller.totalRatingCount,
                              getStarDistribution: controller.getStarDistribution,
                            );
                          }),
                          const SizedBox(height: 20),

                          OutlinedButton(
                            onPressed: () {
                              final productId = controller.rxProduct.value?.id?.toString();
                              if (productId == null) {
                                Get.snackbar(
                                  "Error",
                                  "Cannot review. Product details are still loading.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // Crucial: lets keyboard push up the UI
                                backgroundColor: Colors.transparent,
                                builder: (context) => CreateReviewBottomSheet(
                                  // Added 'onSuccess' callback here
                                  onSubmit: (rating, comment, onSuccess) async {
                                    // Trigger the submission using our ProductDetailController
                                    final response = await controller.submitProductRating(
                                      rating: rating,
                                      comment: comment,
                                    );

                                    if (response != null) {
                                      // Call onSuccess() to swap the sheet's state to the success screen!
                                      onSuccess();
                                    } else if (context.mounted) {
                                      // Show error message only if submission fails
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Failed to submit review. Please try again."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: const Text(
                              "Write a Review",
                              style: TextStyle(
                                color: Color(0xFF3B59F6),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          _buildRelatedProductsHorizontalShowcase(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ======================================================
            // LAYER 2: LOCKED / FIXED SCROLL FLOATING ACTIONS
            // ======================================================
            Positioned(
              top: statusBarHeight + 8,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      radius: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          radius: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.share_outlined, color: Colors.black, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          radius: 20,
                          child: Obx(() => IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                              color: controller.isFavorite.value ? Colors.red : Colors.black,
                              size: 20,
                            ),
                            onPressed: () => controller.toggleFavorite(),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomCartBar(),
    );
  }

  // ==========================================
  // COMPONENT PARTS HELPERS
  // ==========================================
  Widget _buildRelatedProductsHorizontalShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("You Might Also Like", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 110,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 90, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
                    const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text("Related Item", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCartBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Obx(() => Text(
                  '\$${controller.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3B59F6)),
                )),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B59F6),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

