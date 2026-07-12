import 'package:get/get.dart';

class ListStore {
  String? status;
  int? statusCode;
  StoreListData? storeData;

  ListStore({this.status, this.statusCode, this.storeData});

  ListStore.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    storeData = json['data'] != null ? StoreListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (storeData != null) {
      data['data'] = storeData!.toJson();
    }
    return data;
  }
}

// 2. Wrapper for the Store Detail API (Reuses the same StoreItem model!)
class DetailStore {
  String? status;
  int? statusCode;
  StoreItem? storeData;

  DetailStore({this.status, this.statusCode, this.storeData});

  DetailStore.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    storeData = json['data'] != null ? StoreItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (storeData != null) {
      data['data'] = storeData!.toJson();
    }
    return data;
  }
}

// 3. Paginated Data container for Lists
class StoreListData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<StoreItem>? lists;

  StoreListData({this.currentPage, this.lastPage, this.perPage, this.total, this.lists});

  StoreListData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['lists'] != null) {
      lists = <StoreItem>[];
      json['lists'].forEach((v) {
        lists!.add(StoreItem.fromJson(v));
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

// 4. Shared Model used for both individual List items and Details
class StoreItem {
  int? id;
  String? name;
  String? slug;
  String? description;
  String? logo;
  String? banner;
  String? phone;
  String? email;
  String? status;
  bool? isVerified;

  // 1. Made reactive
  RxBool isFav = false.obs;

  Rating? rating;

  // --- Detail-Specific Fields ---
  String? activatedAt;
  int? ratingsAvg;
  int? ratingsCount;
  dynamic myRating;
  int? productCount;
  List<dynamic>? products;

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
    bool? isFav, // Standard bool for constructor
    this.rating,
    this.activatedAt,
    this.ratingsAvg,
    this.ratingsCount,
    this.myRating,
    this.productCount,
    this.products,
  }) {
    // Initialize the RxBool from the constructor parameter
    this.isFav.value = isFav ?? false;
  }

  StoreItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    logo = json['logo'];
    banner = json['banner'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    isVerified = json['is_verified'];

    // 2. Parse into the RxBool safely
    isFav.value = json['is_fav'] ?? false;

    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
    activatedAt = json['activated_at'];
    ratingsAvg = json['ratings_avg'];
    ratingsCount = json['ratings_count'];
    myRating = json['my_rating'];
    productCount = json['product_count'];
    products = json['products'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['logo'] = logo;
    data['banner'] = banner;
    data['phone'] = phone;
    data['email'] = email;
    data['status'] = status;
    data['is_verified'] = isVerified;

    // 3. Access .value for JSON serialization
    data['is_fav'] = isFav.value;

    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    data['activated_at'] = activatedAt;
    data['ratings_avg'] = ratingsAvg;
    data['ratings_count'] = ratingsCount;
    data['my_rating'] = myRating;
    data['product_count'] = productCount;
    data['products'] = products;
    return data;
  }
}

// 5. Nested Rating Class
class Rating {
  int? star;
  int? count;
  String? reviews;

  Rating({this.star, this.count, this.reviews});

  Rating.fromJson(Map<String, dynamic> json) {
    star = json['star'];
    count = json['count'];
    reviews = json['reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['star'] = star;
    data['count'] = count;
    data['reviews'] = reviews;
    return data;
  }
}