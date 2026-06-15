import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/response/list_store.dart';
import '../../controllers/customer_home_controller.dart';

class ListStoreView extends GetView<CustomerController> {
  const ListStoreView({super.key});

  static const double _height = 200;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.storeList.isEmpty) {
        return const SizedBox(
          height: _height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.storeList.isEmpty) {
        return const SizedBox(
          height: _height,
          child: Center(
            child: Text(
              'No featured stores available.',
            ),
          ),
        );
      }

      return SizedBox(
        height: _height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.storeList.length,
          itemBuilder: (_, index) {
            return _StoreCard(
              store: controller.storeList[index],
            );
          },
        ),
      );
    });
  }
}

class _StoreCard extends GetView<CustomerController> {
  const _StoreCard({
    required this.store,
  });

  final StoreItem store;

  @override
  Widget build(BuildContext context) {
    final isFav =
        !controller.isGuestMode && (store.isFav ?? false);

    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            debugPrint('Selected store: ${store.name}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _StoreBanner(store: store),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () =>
                          controller.onStoreFavoriteClick(store),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFav
                              ? Colors.red
                              : Colors.grey.shade700,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 12,
                    bottom: -20,
                    child: Container(
                      width: 46,
                      height: 46,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _StoreLogo(store: store),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  store.name ?? 'Unknown Store',
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              if (store.isVerified == true)
                                const Padding(
                                  padding:
                                  EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.verified,
                                    color: Color(0xFF3B59F6),
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 2),

                          Text(
                            store.description ??
                                'No description available',
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

                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint(
                            'Visit store: ${store.name}',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF3B59F6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Visit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreBanner extends StatelessWidget {
  const _StoreBanner({
    required this.store,
  });

  final StoreItem store;

  @override
  Widget build(BuildContext context) {
    final bannerUrl = store.banner;

    if (bannerUrl == null || bannerUrl.isEmpty) {
      return const _BannerPlaceholder();
    }

    return Image.network(
      bannerUrl,
      height: 95,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (
          context,
          child,
          loadingProgress,
          ) {
        if (loadingProgress == null) {
          return child;
        }

        return const _BannerPlaceholder();
      },
      errorBuilder: (_, __, ___) {
        return const _BannerPlaceholder();
      },
    );
  }
}

class _StoreLogo extends StatelessWidget {
  const _StoreLogo({
    required this.store,
  });

  final StoreItem store;

  @override
  Widget build(BuildContext context) {
    final logoUrl = store.logo;

    if (logoUrl == null || logoUrl.isEmpty) {
      return const _LogoPlaceholder();
    }

    return Image.network(
      logoUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const _LogoPlaceholder();
      },
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.image,
        color: Colors.grey.shade400,
        size: 28,
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      alignment: Alignment.center,
      child: const Icon(
        Icons.store,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}