
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/store_detail/controllers/store_detail_controller.dart';
import 'package:shoppex/shared/widgets/loading_widget.dart';

class StoreProfile extends GetView<StoreDetailController> {
  const StoreProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isDetailsLoading.value) return const LoadingWidget();
      final store = controller.rxStore.value;
      if (store == null) return const Center(child: Text('Store details unavailable.'));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Store Name & Verified Badge
          Row(
            children: [
              Text(
                store.name ?? 'Store Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.verified,
                color: (store.isVerified == true) ? const Color(0xFF3B59F6) : Colors.grey,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Store Description (Newly Added)
          Text(
            store.description ?? 'No description provided.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 12),

          // 3. Stats & Contact Row (Modern Card Style)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Contact Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactRow(Icons.phone_outlined, store.phone ?? 'N/A'),
                        const SizedBox(height: 12),
                        _buildContactRow(Icons.email_outlined, store.email ?? 'N/A'),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, color: Color(0xFFEEEEEE)),
                  // Rating
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(controller.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                          ],
                        ),
                        Text(controller.reviewCount,
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}