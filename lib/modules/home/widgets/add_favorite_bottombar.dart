import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showBottomBar({
  IconData? icon,
  bool? isFavoriteActive,
  String? message,
  String? actionText,
  VoidCallback? onActionTap,
}) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }

  // Handle local null fallbacks safely
  final bool favoriteActive = isFavoriteActive ?? false;
  final IconData displayIcon = icon ?? (favoriteActive ? Icons.favorite : Icons.favorite_border);

  Get.rawSnackbar(
    backgroundColor: Colors.transparent,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    duration: const Duration(milliseconds: 3200),
    animationDuration: const Duration(milliseconds: 500),
    forwardAnimationCurve: Curves.easeOutBack,

    messageText: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1F222A).withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Dynamic Neo-Glass Circle Icon Block
              Center(
                child: Icon(
                  displayIcon,
                  color: favoriteActive ? Colors.redAccent.shade200 : Colors.white70,
                  size: 20,
                ),
              ),
              const SizedBox(width: 6),

              // 2. Message Label Text Segment
              Expanded(
                child: Text(
                  message ?? '', // 🟢 Safe fallback for null string
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // 3. Conditional Interactive Text Action Button
              // 🟢 Only show the button if actionText is actually provided
              if (actionText != null && actionText.isNotEmpty) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Get.closeCurrentSnackbar();
                    if (onActionTap != null) onActionTap();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white.withOpacity(0.05)),
                    ),
                  ),
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      color: Color(0xFF00B0FF),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}


void showErrorBar([String? errorMsg]) { // 🟢 Optional parameter wrapper
  Get.rawSnackbar(
    backgroundColor: Colors.transparent,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(14),
    messageText: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Text(
            errorMsg ?? 'An expected error occurred.', // 🟢 Default string fallback
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}