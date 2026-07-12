import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_home_controller.dart';

class ListStoreView extends GetView<CustomerController> {
  const ListStoreView({super.key});
  static const double _height = 210;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.storeList.isEmpty) {
        return const SizedBox(height: _height, child: Center(child: CircularProgressIndicator()));
      }

      if (controller.storeList.isEmpty) {
        return const SizedBox(height: _height, child: Center(child: Text('No featured stores available.')));
      }

      return SizedBox(
        height: _height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.storeList.length,
          itemBuilder: (_, index) {
            return StoreCard(store: controller.storeList[index]);
          },
        ),
      );
    });
  }
}

class StoreCard extends GetView<CustomerController> {
  const StoreCard({
    super.key,
    required this.store,
    this.width = 260,
    this.sizeType = 2,
  });

  final dynamic store;
  final double width;
  final int sizeType;

  @override
  Widget build(BuildContext context) {
    // We don't wrap the whole build in Obx here anymore.
    // We only use Obx where the data actually changes (the heart icon).
    final int liveIndex = controller.storeList.indexWhere((element) => element.id == store.id);
    final dynamic liveStore = (liveIndex != -1) ? controller.storeList[liveIndex] : store;

    // ====================================================================
    // TYPE 1 STYLE
    // ====================================================================
    if (sizeType == 1) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: _buildBoxDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => controller.onStoreClick(liveStore),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  height: 120,
                  child: Stack(
                    children: [
                      _StoreBanner(store: liveStore, height: 120),
                      Positioned(
                        top: 8,
                        right: 8,
                        // REPLACED: Use the new reactive button
                        child: _FavoriteButton(liveStore: liveStore),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: _buildFloatingLogo(liveStore),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStoreTitle(liveStore),
                        const SizedBox(height: 4),
                        _buildRating(liveStore),
                        const SizedBox(height: 8),
                        _buildVisitButton(liveStore),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ====================================================================
    // TYPE 2 & 3 STYLE
    // ====================================================================
    final double bannerHeight = (sizeType == 3) ? 150 : 115;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: _buildBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => controller.onStoreClick(liveStore),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _StoreBanner(store: liveStore, height: bannerHeight),
                  Positioned(
                    top: 8,
                    right: 8,
                    // REPLACED: Use the new reactive button
                    child: _FavoriteButton(liveStore: liveStore),
                  ),
                  Positioned(
                    left: 12,
                    bottom: -20,
                    child: _buildFloatingLogo(liveStore),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStoreTitle(liveStore),
                          const SizedBox(height: 4),
                          _buildRating(liveStore),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildVisitButton(liveStore),
                  ],
                ),
              ),
              const SizedBox(height: 11),
            ],
          ),
        ),
      ),
    );
  }

// ... (Keep your existing _buildBoxDecoration, _buildStoreTitle, _buildRating, _buildVisitButton, _buildFloatingLogo)
// DELETE: _buildFavoriteIcon (it's replaced by the widget below)
}

// NEW: The Reactive Favorite Button
class _FavoriteButton extends GetView<CustomerController> {
  const _FavoriteButton({required this.liveStore});
  final dynamic liveStore;

  @override
  Widget build(BuildContext context) {
    // Only this small part rebuilds when isFav.value changes
    return Obx(() => GestureDetector(
      onTap: () => controller.onStoreFavoriteClick(liveStore),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          liveStore.isFav.value ? Icons.favorite : Icons.favorite_border,
          color: liveStore.isFav.value ? Colors.red : Colors.grey.shade700,
          size: 18,
        ),
      ),
    ));
  }
}

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildStoreTitle(dynamic liveStore) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Text(
            liveStore.name ?? 'Unknown Store',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        if (liveStore.isVerified == true)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.verified, color: Color(0xFF3B59F6), size: 16),
          ),
      ],
    );
  }

  Widget _buildRating(dynamic liveStore) {
    final double displayStar = (liveStore.ratingsAvg ?? liveStore.rating?.star ?? 0).toDouble();
    final int displayCount = liveStore.ratingsCount ?? liveStore.rating?.count ?? 0;

    String formatCount(int count) {
      if (count >= 1000) {
        return '${(count / 1000).toStringAsFixed(1)}k';
      }
      return count.toString();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: Colors.orange, size: 16),
        const SizedBox(width: 4),
        Text(
          displayStar.toStringAsFixed(1),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(width: 4),
        Text(
          '(${formatCount(displayCount)})',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }

Widget _buildVisitButton(dynamic liveStore) {
  // Use Get.find<CustomerController>() instead of the 'controller' property
  final CustomerController controller = Get.find<CustomerController>();

  return SizedBox(
    height: 32,
    child: ElevatedButton(
      onPressed: () => controller.onStoreVisit(liveStore),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B59F6),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: const Text('Visit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    ),
  );
}

  Widget _buildFloatingLogo(dynamic liveStore) {
    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _StoreLogo(store: liveStore),
      ),
    );
  }

class _StoreBanner extends StatelessWidget {
  const _StoreBanner({required this.store, required this.height});
  final dynamic store;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bannerUrl = store.banner;
    if (bannerUrl == null || bannerUrl.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }
    return Image.network(
      bannerUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(height: height, color: Colors.grey.shade200),
    );
  }
}

class _StoreLogo extends StatelessWidget {
  const _StoreLogo({required this.store});
  final dynamic store;

  @override
  Widget build(BuildContext context) {
    final logoUrl = store.logo;
    if (logoUrl == null || logoUrl.isEmpty) {
      return Container(color: Colors.grey.shade300, child: const Icon(Icons.store, size: 20, color: Colors.grey,));
    }
    return Image.network(logoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300));
  }
}