
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/store_detail/controllers/store_detail_controller.dart';
import '../../../shared/services/make_phone_call.dart';
import '../../../shared/services/send_mail.dart';

class StoreProfile extends GetView<StoreDetailController> {
  const StoreProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final store = controller.rxStore.value;

      // Handle edge cases where deep linking opens the page empty
      if (store == null) {
        return const Center(child: Text('Store details unavailable.'));
      }

      // Helper function to format count strings cleanly (e.g., 12200 -> 12.2k+)
      String formatCount(int count) {
        if (count >= 1000) {
          return '${(count / 1000).toStringAsFixed(1)}k+';
        }
        return count.toString();
      }

      final int pCount = store.productCount ?? 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Store Name & Verified Badge
          Row(
            children: [
              Text(
                store.name ?? 'Store Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.verified,
                color: (store.isVerified == true) ? const Color(0xFF3B59F6) : Colors.grey,
                size: 18,
              ),
            ],
          ),

          // 2. Store Description
          Text(
            store.description ?? 'No description provided.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 6),

          // 3. Store Lifetime Row
          Row(
            children: [
              const Icon(Icons.history_toggle_off_outlined, size: 14, color: Color(0xFF3B59F6)),
              const SizedBox(width: 4),
              Text(
                controller.storeLifetime,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3B59F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 4. Stats & Contact Row (Modern Integrated Card Style)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Contact Info (Left Section) - Fully Clickable Now
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildContactRow(Icons.phone_outlined, store.phone ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildContactRow(Icons.email_outlined, store.email ?? 'N/A'),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, color: Colors.black45),

                  // Dynamic Ratings Section (Middle Section)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.ratingsAvg.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '(${formatCount(controller.ratingsCount)} Reviews)',
                          style: const TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, color: Colors.black45),

                  // Dynamic Product Inventory Status (Right Section with Low Stock warning)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (pCount > 0) ...[
                          Text(
                            '$pCount',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          pCount == 0
                              ? 'Out of Stock'
                              : (pCount <= 2 ? 'Low Stock' : 'In Stock'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: pCount == 0
                                ? Colors.red
                                : (pCount <= 2 ? Colors.orange : const Color(0xFF3B59F6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Widget _buildContactRow(IconData icon, String value) {
    final bool isPhone = icon == Icons.phone_outlined && value != 'N/A';
    final bool isEmail = icon == Icons.email_outlined && value != 'N/A';
    final bool isClickable = isPhone || isEmail;

    return InkWell(
      onTap: isClickable
          ? () {
        if (isPhone) {
          controller.isPhoneClicked.value = true;
          makePhoneCall(value);
        }
        if (isEmail) {
          controller.isEmailClicked.value = true; // Set email clicked state
          sendEmail(value); // Trigger your email function
        }
      }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isClickable ? Colors.black87 : Colors.grey,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() {
                // Read BOTH values unconditionally to satisfy GetX Obx requirements
                final bool phoneClicked = controller.isPhoneClicked.value;
                final bool emailClicked = controller.isEmailClicked.value;

                // Determine if THIS specific row layout should be bold
                final bool shouldBeBold = (isPhone && phoneClicked) || (isEmail && emailClicked);

                return Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isClickable ? Colors.black87 : Colors.grey,
                    // Starts normal black, turns bold black after it is tapped
                    fontWeight: shouldBeBold ? FontWeight.bold : FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}