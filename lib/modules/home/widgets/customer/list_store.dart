import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/response/list_store.dart';
import '../../controllers/home_controller.dart';

class ListStoreView extends GetView<HomeController> {
  const ListStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 140,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.storeList.isEmpty) {
        return const SizedBox(
          height: 140,
          child: Center(child: Text('No featured stores available.')),
        );
      }

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemCount: controller.storeList.length,
          itemBuilder: (context, index) {
            final store = controller.storeList[index];
            return _buildStoreCard(store, index);
          },
        ),
      );
    });
  }

  // Individual Store Card Widget
  Widget _buildStoreCard(StoreItem store, int index) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          onTap: () {
            controller.onListStoreClick();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner & Logo & Favorite Button Overlay
              Stack(
                clipBehavior: Clip.none,
                children: [
                  store.banner != null && store.banner!.isNotEmpty
                      ? Image.network(
                    store.banner!,
                    height: 95,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildBannerPlaceholder(),
                  )
                      : _buildBannerPlaceholder(),

                  // Add to Favorite Button (Top Right Overlay)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final storeId = store.id;
                      final isUpdating = controller.favoriteStoreIds.contains(storeId);

                      // 🟢 ONLY evaluate as favorite if the user IS NOT a guest
                      final isFav = !controller.isGuestMode && (store.isFav ?? false);

                      return GestureDetector(
                        onTap: isUpdating ? null : () => controller.onStoreFavoriteClick(store),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: isUpdating
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B59F6)),
                            ),
                          )
                              : Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey.shade700,
                            size: 18,
                          ),
                        ),
                      );
                    }),
                  ),
                  // Floating Logo Circle/Square
                  Positioned(
                    left: 12,
                    bottom: -20,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: store.logo != null && store.logo!.isNotEmpty
                            ? Image.network(
                          store.logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildLogoPlaceholder(),
                        )
                            : _buildLogoPlaceholder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Store Info Details Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  store.name ?? 'Unknown Store',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (store.isVerified == true) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xFF3B59F6),
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),

                          Text(
                            store.description ?? 'No description available',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Visit Action Button
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.onListStoreVisit();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B59F6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Visit',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerPlaceholder() {
    return Container(
      height: 95,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Icon(Icons.image, color: Colors.grey.shade400, size: 28),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      color: Colors.blueAccent,
      child: const Icon(Icons.store, color: Colors.white, size: 20),
    );
  }
}