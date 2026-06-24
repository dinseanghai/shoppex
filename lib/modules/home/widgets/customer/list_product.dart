import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../data/models/response/list_product.dart';
import '../../controllers/customer_home_controller.dart';

class ListProductView extends GetView<CustomerController> {
  const ListProductView({super.key});

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.68,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.productList;

      if (controller.isLoading.value && products.isEmpty) {
        return SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate(
                (_, __) => const ProductSkeletonItem(),
            childCount: 4,
          ),
        );
      }

      if (products.isEmpty) {
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 140,
            child: Center(
              child: Text('No products available'),
            ),
          ),
        );
      }

      return SliverMainAxisGroup(
        slivers: [
          SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return ProductCardItem(
                  product: products[index],
                );
              },
              childCount: products.length,
            ),
          ),

          if (controller.isMoreLoading.value)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF3B59F6),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class ProductCardItem extends GetView<CustomerController> {
  const ProductCardItem({
    super.key,
    required this.product,
  });

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    final isFav =
        !controller.isGuestMode && product.isFavorite == true;

    final imageUrl = product.thumbnail ?? product.image;

    return InkWell(
      onTap: () {
        controller.onProductClick(product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: const Color(0xFFF6F6F6),
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                          ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    )
                        : const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),

                if ((product.discountPercent ?? 0) > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6D00),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () =>
                        controller.onProductFavoriteClick(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.black45,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        '\$${product.salePrice ?? product.basePrice ?? '0'}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(width: 6),

                      if ((product.discountPercent ?? 0) > 0 &&
                          product.basePrice != null)
                        Text(
                          '\$${product.basePrice}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration:
                            TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 14,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        product.ratingAvg ?? '0.0',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 2),

                      Text(
                        '(${product.ratingCount ?? 0})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSkeletonItem extends StatelessWidget {
  const ProductSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(
                  width: double.infinity,
                  height: 12,
                ),

                const SizedBox(height: 6),

                const _SkeletonBox(
                  width: 120,
                  height: 12,
                ),

                const SizedBox(height: 12),

                const _SkeletonBox(
                  width: 50,
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}