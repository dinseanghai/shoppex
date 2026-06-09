import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/controllers/home_controller.dart';

import '../../../../data/models/response/list_product.dart';

class ListProductView extends GetView<HomeController> {
  const ListProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Trending Products',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('See All', style: TextStyle(color: Colors.blue, fontSize: 14)),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        // 1. Handling the loading skeleton state
        if (controller.isLoading.value) {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => const ProductSkeletonItem(),
          );
        }

        // 2. Handling empty data array states
        if (controller.productList.isEmpty) {
          return const Center(
            child: Text(
              "No products available.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // 3. Grid representation matching the UI spec sheet layout
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final ProductItem product = controller.productList[index];
            return ProductCardItem(
              product: product,
              onFavoriteToggle: () {
                // Safely handle favorite interactions through controller context
                product.isFavorite = !(product.isFavorite ?? false);
                controller.productList.refresh();
              },
            );
          },
        );
      }),
    );
  }
}

class ProductCardItem extends StatelessWidget {
  final ProductItem product;
  final VoidCallback onFavoriteToggle;

  const ProductCardItem({
    Key? key,
    required this.product,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: const Color(0xFFF6F6F6),
                  child: product.thumbnail != null || product.image != null
                      ? Image.network(
                    product.thumbnail ?? product.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  )
                      : const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
              if (product.discountPercent != null && product.discountPercent! > 0)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-${product.discountPercent}%',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      product.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: product.isFavorite == true ? Colors.red : Colors.black45,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${product.salePrice ?? product.basePrice ?? '0'}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(width: 6),
                    if (product.discountPercent != null && product.discountPercent! > 0 && product.basePrice != null)
                      Text(
                        '\$${product.basePrice}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      product.ratingAvg ?? '0.0',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '(${product.ratingCount ?? 0})',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductSkeletonItem extends StatelessWidget {
  const ProductSkeletonItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 6),
                Container(height: 12, width: 120, decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 12),
                Container(height: 10, width: 50, decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(4))),
              ],
            ),
          )
        ],
      ),
    );
  }
}