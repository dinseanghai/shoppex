
class DetailProduct {
  final int? id;
  final String? name;
  final String? slug;
  final String? shortDescription;
  final String? description;
  final String? sku;
  final String? basePrice;
  final String? salePrice;
  final int? discountPercent;
  final String? ratingAvg;
  final int? ratingCount;
  final bool? isFeatured;
  final String? publishedAt;
  final String? image;
  final String? thumbnail;
  final bool? isFavorite;
  final int? myRating; // Added this property to keep track of user's own rating
  final Store? store;
  final Category? category;
  final List<ProductImage>? images;
  final List<dynamic>? variants; // Left as dynamic since sample payload is empty []

  DetailProduct({
    this.id,
    this.name,
    this.slug,
    this.shortDescription,
    this.description,
    this.sku,
    this.basePrice,
    this.salePrice,
    this.discountPercent,
    this.ratingAvg,
    this.ratingCount,
    this.isFeatured,
    this.publishedAt,
    this.image,
    this.thumbnail,
    this.isFavorite,
    this.myRating,
    this.store,
    this.category,
    this.images,
    this.variants,
  });

  /// The copyWith method to allow updating ratings dynamically without losing other fields
  DetailProduct copyWith({
    int? id,
    String? name,
    String? slug,
    String? shortDescription,
    String? description,
    String? sku,
    String? basePrice,
    String? salePrice,
    int? discountPercent,
    double? ratingAvg, // Accepts double (from RatingResponseModel) and formats back to String cleanly
    int? ratingCount,
    bool? isFeatured,
    String? publishedAt,
    String? image,
    String? thumbnail,
    bool? isFavorite,
    int? myRating,
    Store? store,
    Category? category,
    List<ProductImage>? images,
    List<dynamic>? variants,
  }) {
    return DetailProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      basePrice: basePrice ?? this.basePrice,
      salePrice: salePrice ?? this.salePrice,
      discountPercent: discountPercent ?? this.discountPercent,
      ratingAvg: ratingAvg != null ? ratingAvg.toString() : this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      isFeatured: isFeatured ?? this.isFeatured,
      publishedAt: publishedAt ?? this.publishedAt,
      image: image ?? this.image,
      thumbnail: thumbnail ?? this.thumbnail,
      isFavorite: isFavorite ?? this.isFavorite,
      myRating: myRating ?? this.myRating,
      store: store ?? this.store,
      category: category ?? this.category,
      images: images ?? this.images,
      variants: variants ?? this.variants,
    );
  }

  factory DetailProduct.fromJson(Map<String, dynamic> json) {
    return DetailProduct(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      sku: json['sku'] as String?,
      basePrice: json['base_price'] as String?,
      salePrice: json['sale_price'] as String?,
      discountPercent: json['discount_percent'] as int?,
      ratingAvg: json['rating_avg']?.toString(), // Safely handle if backend changes to double/int
      ratingCount: json['rating_count'] as int?,
      isFeatured: json['is_featured'] as bool?,
      publishedAt: json['published_at'] as String?,
      image: json['image'] as String?,
      thumbnail: json['thumbnail'] as String?,
      isFavorite: json['is_favorite'] as bool?,
      myRating: json['my_rating'] as int?,
      store: json['store'] != null ? Store.fromJson(json['store'] as Map<String, dynamic>) : null,
      category: json['category'] != null ? Category.fromJson(json['category'] as Map<String, dynamic>) : null,
      images: json['images'] != null
          ? (json['images'] as List).map((i) => ProductImage.fromJson(i as Map<String, dynamic>)).toList()
          : null,
      variants: json['variants'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'short_description': shortDescription,
      'description': description,
      'sku': sku,
      'base_price': basePrice,
      'sale_price': salePrice,
      'discount_percent': discountPercent,
      'rating_avg': ratingAvg,
      'rating_count': ratingCount,
      'is_featured': isFeatured,
      'published_at': publishedAt,
      'image': image,
      'thumbnail': thumbnail,
      'is_favorite': isFavorite,
      'my_rating': myRating,
      'store': store?.toJson(),
      'category': category?.toJson(),
      'images': images?.map((i) => i.toJson()).toList(),
      'variants': variants,
    };
  }
}

class Store {
  final int? id;
  final String? name;
  final String? slug;
  final String? logo;
  final bool? isVerified;

  Store({this.id, this.name, this.slug, this.logo, this.isVerified});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      logo: json['logo'] as String?,
      isVerified: json['is_verified'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'logo': logo,
    'is_verified': isVerified,
  };
}

class Category {
  final int? id;
  final String? name;
  final String? slug;

  Category({this.id, this.name, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
  };
}

class ProductImage {
  final int? id;
  final String? path;
  final String? thumbnailPath;
  final String? altText;
  final int? sortOrder;
  final bool? isPrimary;

  ProductImage({
    this.id,
    this.path,
    this.thumbnailPath,
    this.altText,
    this.sortOrder,
    this.isPrimary,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int?,
      path: json['path'] as String?,
      thumbnailPath: json['thumbnail_path'] as String?,
      altText: json['alt_text'] as String?,
      sortOrder: json['sort_order'] as int?,
      isPrimary: json['is_primary'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'thumbnail_path': thumbnailPath,
    'alt_text': altText,
    'sort_order': sortOrder,
    'is_primary': isPrimary,
  };
}