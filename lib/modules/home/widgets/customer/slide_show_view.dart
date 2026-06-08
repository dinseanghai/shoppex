import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppex/modules/home/controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../shared/widgets/loading_widget.dart';

class SlideShowView extends GetView<HomeController> {
  const SlideShowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return  SizedBox(
          height: 210,
          child: Center(child: LoadingWidget()),
        );
      }

      final activeSlides = controller.slideList
          .where((slide) => slide.status?.toLowerCase() != 'inactive')
          .toList();

      if (activeSlides.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- BANNER CAROUSEL ---
          CarouselSlider.builder(
            itemCount: activeSlides.length,
            options: CarouselOptions(
              height: 180,
              viewportFraction: 1,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                controller.updateIndex(index);
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final slide = activeSlides[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // 1. Full-Screen Server Image Background
                      Positioned.fill(
                        child: Image.network(
                          slide.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF3D5AFE),
                              child: const Icon(Icons.broken_image, color: Colors.white, size: 40),
                            );
                          },
                        ),
                      ),

                      // 2. Dark Linear Gradient Overlay (Brings absolute contrast)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),   // Clear top
                                Colors.black.withOpacity(0.4),   // Subtle mid tint
                                Colors.black.withOpacity(0.85),  // Deep solid base for text crispness
                              ],
                              stops: const [0.15, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // 3. Typography Content Layout
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16, // Anchored tightly into the dark gradient zone
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // --- NEW: TITLE WITH FF6D00 BACKGROUND BADGE ---
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6D00), // Solid pop orange background
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (slide.title ?? '').toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Subtitle (Cinematic Large Font)
                            Text(
                              slide.subtitle ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),

                            // Description (Clean paragraph blocks like image_8bcca1.jpg)
                            if (slide.description != null && slide.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                slide.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85), // Soft contrasting white
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          // --- SYNCHRONIZED DOT INDICATOR ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: activeSlides.asMap().entries.map((entry) {
              bool isActive = controller.currentIndex.value == entry.key;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isActive ? 22.0 : 7.0,
                height: 7.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? const Color(0xFF3D5AFE) // Keeps your primary theme accent color for indicators
                      : Colors.grey.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}