import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely capture system notch and status bar heights
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
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B59F6)),
                  child: const Text("Go Back", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          );
        }

        final imageUrl = product.thumbnail ?? product.image;

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
                          child: imageUrl != null
                              ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            // 🟢 1. Handle loading state seamlessly
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Color(0xFF3B59F6),
                                ),
                              );
                            },
                            // 🟢 2. Safely catch 404s, 500s, or offline network errors
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
                          )
                              : const Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                        // Discount Badge overlay
                        if ((product.discountPercent ?? 0) > 0)
                          Positioned(
                            top: statusBarHeight + 64, // Positions safely clear below the floating fixed bar
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
                        // Slider Carousel Dot overlay Indicators
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 16, height: 5, decoration: BoxDecoration(color: const Color(0xFF3B59F6), borderRadius: BorderRadius.circular(4))),
                              const SizedBox(width: 4),
                              Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                            ],
                          ),
                        )
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(4)),
                                child: const Text("Save \$120", style: TextStyle(color: Color(0xFFFF6D00), fontWeight: FontWeight.bold, fontSize: 11)),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Verified Seller and Ratings Banner Line
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(product.ratingAvg ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 4),
                              Text('(${product.ratingCount ?? ''} )', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    CircleAvatar(radius: 8, backgroundColor: const Color(0xFF3B59F6), child: const Text("TH", style: TextStyle(fontSize: 7, color: Colors.white))),
                                    const SizedBox(width: 4),
                                    const Text("TechHub Pro", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_outlined, size: 14, color: Color(0xFF3B59F6)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Divider(height: 32, color: Color(0xFFF5F5F5)),

                          // Color Matrix Custom Options Picker Block Layout
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Obx(() {
                                final textColors = ["Black", "Silver", "White"];
                                return Text(
                                  textColors[controller.selectedColorIndex.value],
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(3, (index) {
                              final colors = [const Color(0xFF1F222B), const Color(0xFFE5E5E5), Colors.white];
                              return Obx(() => GestureDetector(
                                onTap: () => controller.selectedColorIndex.value = index,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: controller.selectedColorIndex.value == index ? const Color(0xFF3B59F6) : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: colors[index],
                                    child: colors[index] == Colors.white
                                        ? Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)))
                                        : null,
                                  ),
                                ),
                              ));
                            }),
                          ),
                          const SizedBox(height: 20),

                          // Sizes Selection Widget Chips Array Configuration
                          const Text("Size / Model", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildSizeOption("Standard", 0),
                              const SizedBox(width: 10),
                              _buildSizeOption("Bundle + Case", 1),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Inventory Level and Step Counters Module Block
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
                                          style: IconButton.styleFrom(backgroundColor: const Color(0xFF3B59F6), foregroundColor: Colors.white, minimumSize: const Size(24, 24), padding: EdgeInsets.zero),
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
                                  const Text("In Stock: 48 pcs", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 40, color: Color(0xFFF5F5F5)),

                          // Descriptions Dropdown Content Area
                          _buildCollapsibleDescriptionSection(),
                          const Divider(height: 40, color: Color(0xFFF5F5F5)),

                          // Statistical Graphic Bar Diagrams
                          _buildReviewAnalysisDistribution(product),
                          const SizedBox(height: 20),

                          // Individual Customer Reviews Mock Widgets
                          _buildUserCommentCard(
                            name: "Sarah R.",
                            date: "2 days ago",
                            rating: 5,
                            comment: "Absolutely worth every penny. The noise cancellation is mind-blowing on flights and the comfort is unmatched even after 8h of use.",
                            hasImage: true,
                          ),
                          _buildUserCommentCard(
                            name: "Marcus J.",
                            date: "1 week ago",
                            rating: 4,
                            comment: "Great sound quality and battery life. Build feels premium. Slightly tight clamp at first but loosens up after a few days.",
                            hasImage: true,
                          ),

                          // Infinite Reviews Navigation Button Element
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: const Text("See all 1,248 reviews", style: TextStyle(color: Color(0xFF3B59F6), fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          const SizedBox(height: 32),

                          // Horizontal Product Recommendations Carousel
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
                  // Pinned Back Action Trigger with Shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
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

                  // Pinned Utility Control Set Row with Shadows
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
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
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          radius: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                              color: controller.isFavorite.value ? Colors.red : Colors.black,
                              size: 20,
                            ),
                            onPressed: () => controller.toggleFavorite(),
                          ),
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

  // Helper Custom Widget Components Configuration Subsections
  Widget _buildSizeOption(String text, int index) {
    return Obx(() {
      final isSelected = controller.selectedSizeIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectedSizeIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3B59F6) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? const Color(0xFF3B59F6) : const Color(0xFFE0E0E0)),
          ),
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      );
    });
  }

  Widget _buildCollapsibleDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Product Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Icon(Icons.keyboard_arrow_up, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Industry-leading noise cancellation with Auto NC Optimizer. Crystal clear hands-free calling and Alexa voice control. Up to 30-hour battery life with quick charge (3 min for 3 hours of playback)...",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {},
          child: const Text("Read more", style: TextStyle(color: Color(0xFF3B59F6), fontWeight: FontWeight.bold, fontSize: 13)),
        )
      ],
    );
  }

  Widget _buildReviewAnalysisDistribution(dynamic product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ratings & Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("4.8", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
                Row(children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.orange, size: 14))),
                const SizedBox(height: 4),
                const Text('1,248 ratings', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                children: [
                  _buildStatRow("5", 0.82, "82%"),
                  _buildStatRow("4", 0.12, "12%"),
                  _buildStatRow("3", 0.04, "4%"),
                  _buildStatRow("2", 0.01, "1%"),
                  _buildStatRow("1", 0.01, "1%"),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildStatRow(String starNumber, double ratio, String percentText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      key: ValueKey(starNumber),
      child: Row(
        children: [
          Text(starNumber, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: const Color(0xFFF5F5F5),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text(percentText, textAlign: TextAlign.end, style: const TextStyle(fontSize: 11, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildUserCommentCard({required String name, required String date, required int rating, required String comment, required bool hasImage}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: Color(0xFFE0E0E0), child: Icon(Icons.person, size: 18, color: Colors.white)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Row(children: List.generate(5, (i) => Icon(Icons.star, color: i < rating ? Colors.orange : Colors.grey.shade300, size: 12))),
                    ],
                  )
                ],
              ),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: TextStyle(color: Colors.grey.shade800, fontSize: 12, height: 1.4)),
          if (hasImage) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(width: 50, height: 50, color: const Color(0xFFF5F5F5), child: const Icon(Icons.image, size: 20, color: Colors.grey)),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildRelatedProductsHorizontalShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Related Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text("See all", style: TextStyle(color: Color(0xFF3B59F6), fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildHorizontalShowcaseCard("TrueLoop Wireless Earbuds", "\$89", "\$120", "4.6"),
              _buildHorizontalShowcaseCard("Smart Watch Pro Series 8", "\$249", "\$320", "4.7"),
              _buildHorizontalShowcaseCard("JBL Studio Headphones", "\$159", "\$199", "4.5"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHorizontalShowcaseCard(String title, String salePrice, String oldPrice, String stars) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 120,
              width: 140,
              color: const Color(0xFFF5F5F5),
              child: const Icon(Icons.headphones, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, height: 1.2)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(salePrice, style: const TextStyle(color: Color(0xFF3B59F6), fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(width: 4),
              Text(oldPrice, style: const TextStyle(color: Colors.grey, fontSize: 10, decoration: TextDecoration.lineThrough)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 12),
              const SizedBox(width: 2),
              Text(stars, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomCartBar() {
    final controller = Get.find<ProductDetailController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -4))
        ],
      ),
      // 🟢 Obx makes this specific widget reactive
      child: Obx(() => ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B59F6),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Text(
          "(\$${controller.totalPrice.toStringAsFixed(2)}) Add to Cart ",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      )),
    );
  }
}