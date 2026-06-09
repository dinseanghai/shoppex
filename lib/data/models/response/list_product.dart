class ListProduct {
  String? status;
  int? statusCode;
  ProductData? productData; // Changed from Data?

  ListProduct({this.status, this.statusCode, this.productData});

  ListProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    productData = json['data'] != null ? new ProductData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    if (this.productData != null) {
      data['data'] = this.productData!.toJson();
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
  List<ProductItem>? lists; // Changed from List<Lists>?

  ProductData({this.currentPage, this.lastPage, this.perPage, this.total, this.lists});

  ProductData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['lists'] != null) {
      lists = <ProductItem>[]; // Changed from Lists
      json['lists'].forEach((v) {
        lists!.add(new ProductItem.fromJson(v)); // Changed from Lists
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
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

  ProductItem(
      {this.id,
        this.name,
        this.slug,
        this.basePrice,
        this.salePrice,
        this.discountPercent,
        this.ratingAvg,
        this.ratingCount,
        this.image,
        this.thumbnail,
        this.isFavorite});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['base_price'] = this.basePrice;
    data['sale_price'] = this.salePrice;
    data['discount_percent'] = this.discountPercent;
    data['rating_avg'] = this.ratingAvg;
    data['rating_count'] = this.ratingCount;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}