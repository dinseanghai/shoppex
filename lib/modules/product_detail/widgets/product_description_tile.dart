import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_detail_controller.dart';

class ProductDescriptionTile extends StatelessWidget {
  final String? shortDesc;
  final String? description;

  const ProductDescriptionTile({super.key, this.shortDesc, this.description});

  @override
  Widget build(BuildContext context) {
    final ProductDetailController controller = Get.find<ProductDetailController>();

    final textContent = description ?? 'No description available for this product.';

    final TextStyle customTextStyle = description == null
        ? const TextStyle(
      fontSize: 14,
      color: Color(0xFF9E9E9E),
      fontStyle: FontStyle.italic,
    )
        : const TextStyle(
      fontSize: 14,
      color: Color(0xFF757575),
      height: 1.6,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background of your tile card
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      // 🟢 1. Wrap with Theme to override the default tap colors
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: const Text(
            "Product Description",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
          initiallyExpanded: true,

          // 🟢 2. Setting the shape border radius for expansion behaviors
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

          tilePadding: const EdgeInsets.symmetric(horizontal: 4),
          childrenPadding: const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 16),

          children: [
            if (shortDesc != null) ...[
              Transform.translate(
                offset: const Offset(0, -4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    shortDesc!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A4A4A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final textPainter = TextPainter(
                  text: TextSpan(text: textContent, style: customTextStyle),
                  maxLines: 3,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);

                final bool exceedsMaxLines = textPainter.didExceedMaxLines;

                return Obx(() {
                  final isExpanded = controller.isExpanded.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: shortDesc != null ? 0 : 4),
                        child: Text(
                          textContent,
                          style: customTextStyle,
                          maxLines: isExpanded ? null : 3,
                          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        ),
                      ),
                      if (exceedsMaxLines) ...[
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: controller.toggleExpanded,
                          child: Text(
                            isExpanded ? "Read less" : "Read more...",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B59F6),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}