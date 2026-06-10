class ListProduct {
  String? status;
  int? statusCode;
  ProductData? productData;
  int? page; // 👈 🟢 1. Added page variable parameter for pagination tracking

  // 2. Added to the optional constructor block parameters
  ListProduct({this.status, this.statusCode, this.productData, this.page});

  ListProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    productData = json['data'] != null ? ProductData.fromJson(json['data']) : null;
    page = json['page']; // (Optional) maps back if returned from server
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (productData != null) {
      data['data'] = productData!.toJson();
    }
    // 3. 🟢 Packing 'page' into the dynamic map conversion payload out to Dio
    if (page != null) {
      data['page'] = page;
    }
    return data;
  }
}

// Renamed from Data to ProductData
class ProductData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<ProductItem>? lists;

  ProductData({this.currentPage, this.lastPage, this.perPage, this.total, this.lists});

  ProductData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['lists'] != null) {
      lists = <ProductItem>[];
      json['lists'].forEach((v) {
        lists!.add(ProductItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    if (lists != null) {
      data['lists'] = lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Renamed from Lists to ProductItem
class ProductItem {
  int? id;
  String? name;
  String? slug;
  String? basePrice;
  String? salePrice;
  int? discountPercent;
  String? ratingAvg;
  int? ratingCount;
  String? image;
  String? thumbnail;
  bool? isFavorite;

  ProductItem({
    this.id,
    this.name,
    this.slug,
    this.basePrice,
    this.salePrice,
    this.discountPercent,
    this.ratingAvg,
    this.ratingCount,
    this.image,
    this.thumbnail,
    this.isFavorite,
  });

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    basePrice = json['base_price'];
    salePrice = json['sale_price'];
    discountPercent = json['discount_percent'];
    ratingAvg = json['rating_avg'];
    ratingCount = json['rating_count'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['base_price'] = basePrice;
    data['sale_price'] = salePrice;
    data['discount_percent'] = discountPercent;
    data['rating_avg'] = ratingAvg;
    data['rating_count'] = ratingCount;
    data['image'] = image;
    data['thumbnail'] = thumbnail;
    data['is_favorite'] = isFavorite;
    return data;
  }
}