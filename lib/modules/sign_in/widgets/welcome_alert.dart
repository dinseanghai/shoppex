import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showWelcomeAlert({required String userName, bool isGuest = false}) {
  Get.rawSnackbar(
    backgroundColor: Colors.transparent,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    duration: const Duration(milliseconds: 2800),
    animationDuration: const Duration(milliseconds: 500),
    forwardAnimationCurve: Curves.easeOutBack, // Playful premium spring animation

    messageText: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        // The core glassmorphic blur intensity
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Translucent glass base color (darkens or lightens depending on overlay)
            color: const Color(0xFF184779).withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              // Sharp modern sub-pixel rim lighting edge
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Dynamic Neo-Glass Minimal Ring Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isGuest
                      ? Colors.amber.withOpacity(0.15)
                      : const Color(0xFF3D5AFE).withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isGuest
                        ? Colors.amber.withOpacity(0.3)
                        : const Color(0xFF3D5AFE).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isGuest ? Icons.auto_awesome_rounded : Icons.face_unlock_outlined,
                    color: isGuest ? Colors.amber.shade300 : const Color(0xFF8C9EFF),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Sophisticated Clean Typography Layout
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGuest ? "GUEST MODE ACTIVE" : "SUCCESSFUL LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8, // Elegant wide tracking style
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isGuest ? "Welcome to ShopeeX" : "Welcome back, $userName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}