class DetailStore {
  final String? status;
  final int? statusCode;
  final StoreItem? storeData;

  DetailStore({
    this.status,
    this.statusCode,
    this.storeData,
  });

  factory DetailStore.fromJson(Map<String, dynamic> json) {
    return DetailStore(
      status: json['status'] as String?,
      statusCode: json['status_code'] as int?,
      storeData: json['data'] != null ? StoreItem.fromJson(json['data']) : null,
    );
  }
}

/// Core Store detail model that handles basic initial view state fields
/// as well as deeply synchronized background network values.
class StoreItem {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? logo;
  final String? banner;
  final String? phone;
  final String? email;
  final String? status;
  final bool? isVerified;
  String? activatedAt; // Non-final to allow smooth reactive updates
  bool? isFav;         // Non-final to allow local toggle updates
  double? ratingsAvg;
  int? ratingsCount;
  dynamic myRating;
  int? productCount;
  List<ProductItem>? products; // Maps cleanly to your ProductCardItem widgets

  StoreItem({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.logo,
    this.banner,
    this.phone,
    this.email,
    this.status,
    this.isVerified,
    this.activatedAt,
    this.isFav,
    this.ratingsAvg,
    this.ratingsCount,
    this.myRating,
    this.productCount,
    this.products,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      isVerified: json['is_verified'] as bool?,
      activatedAt: json['activated_at'] as String?,
      isFav: json['is_fav'] as bool? ?? false,

      // Safely fallback and parse rating variations from the API
      ratingsAvg: (json['ratings_avg'] ?? json['rating']?['star'] ?? 0.0).toDouble(),
      ratingsCount: json['ratings_count'] ?? json['rating']?['count'] ?? 0,

      myRating: json['my_rating'],
      productCount: json['product_count'] as int? ?? 0,

      // FIXED: Parses incoming elements by checking if they are already mapped objects or raw maps
      products: json['products'] != null
          ? List<ProductItem>.from(
        (json['products'] as List).map((x) {
          if (x is ProductItem) return x;
          return ProductItem.fromJson(x as Map<String, dynamic>);
        }),
      )
          : [],
    );
  }
}

/// The specific model mapping required to satisfy your ProductCardItem widget properties.
class ProductItem {
  final int? id;
  final String? name;
  final String? slug;
  final String? thumbnail;
  final String? image;
  final int? discountPercent;
  final bool? isFavorite;
  final double? salePrice;
  final double? basePrice;
  final String? ratingAvg;
  final int? ratingCount;

  ProductItem({
    this.id,
    this.name,
    this.slug,
    this.thumbnail,
    this.image,
    this.discountPercent,
    this.isFavorite,
    this.salePrice,
    this.basePrice,
    this.ratingAvg,
    this.ratingCount,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      thumbnail: json['thumbnail'] as String?,
      image: (json['image_path'] ?? json['image']) as String?,
      discountPercent: json['discount_percent'] as int? ?? 0,
      isFavorite: (json['is_favorite'] ?? json['is_fav']) as bool? ?? false,

      // Convert internal numeric prices to doubles safely
      salePrice: json['sale_price'] != null ? (json['sale_price']).toDouble() : null,
      basePrice: json['base_price'] != null ? (json['base_price']).toDouble() : null,

      // Rating parsing logic matching item view requirements
      ratingAvg: json['rating_avg']?.toString() ?? '0.0',
      ratingCount: json['rating_count'] as int? ?? 0,
    );
  }
}