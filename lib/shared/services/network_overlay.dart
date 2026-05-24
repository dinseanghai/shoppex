import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'network_service.dart';

class NetworkOverlay extends StatelessWidget {
  final Widget child;

  const NetworkOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your primary app views remain running natively underneath
        Positioned.fill(child: child),

        // GLASSMORPHISM CONTAINER & INTERACTION SHIELD
        Obx(() {
          final networkService = Get.find<NetworkService>();
          final isOffline = !networkService.isOnline.value;

          // 🔥 FIXED THE BUG HERE:
          // Instead of guessing with Get.currentRoute string checks during fast transitions,
          // we use the master boolean flag managed by your controllers.
          if (!networkService.isOverlayAllowed.value) {
            return const SizedBox.shrink(); // Stays completely silent during Onboarding
          }

          // If the device is back online, strip the layout block immediately
          if (!isOffline) return const SizedBox.shrink();

          // Connection Lost: Build the absolute full-screen blurred blockade with floating dialog card
          return Positioned.fill(
            child: AbsorbPointer(
              absorbing: true, // Stops any tap gestures from bleeding into fields underneath
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Stack(
                  children: [
                    // A. Global Ambient Background Blur
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          color: const Color(0xFF0D1B2A).withOpacity(0.3), // Dark blue/gray tint
                        ),
                      ),
                    ),

                    // B. Floating Card Layout (Matches your design mockups)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0), // Deep frosted glass card look
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                              decoration: BoxDecoration(
                                color: const Color(0xFF146BCA).withOpacity(0.3), // Premium sapphire blue frost blend
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15), // Crisp highlight edge border
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Hug content snugly like a card dialog
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 1. Red Alert Connection Status Glow Badge
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE53935).withOpacity(0.2), // Red ambient ring glow
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.wifi_off_outlined,
                                        color: Color(0xFFE53935),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // 2. Main Title Text
                                  const Text(
                                    "Connection Lost",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // 3. Informative Sub-Message
                                  const Text(
                                    "Searching for network...\nPlease wait while we attempt to reconnect.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // 4. Custom Subtle Spinner
                                  const SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}