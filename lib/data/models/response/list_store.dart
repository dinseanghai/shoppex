class ListStore {
  String? status;
  int? statusCode;
  StoreData? storeData; // Changed from Data?

  ListStore({this.status, this.statusCode, this.storeData});

  ListStore.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    storeData = json['data'] != null ? new StoreData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    if (this.storeData != null) {
      data['data'] = this.storeData!.toJson();
    }
    return data;
  }
}

// Renamed from Data to StoreData
class StoreData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<StoreItem>? lists; // Changed from List<Lists>?

  StoreData({this.currentPage, this.lastPage, this.perPage, this.total, this.lists});

  StoreData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['lists'] != null) {
      lists = <StoreItem>[]; // Changed from Lists
      json['lists'].forEach((v) {
        lists!.add(new StoreItem.fromJson(v)); // Changed from Lists
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

// Renamed from Lists to StoreItem
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
  bool? isFav;

  StoreItem(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.logo,
        this.banner,
        this.phone,
        this.email,
        this.status,
        this.isVerified,
        this.isFav});

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
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['status'] = this.status;
    data['is_verified'] = this.isVerified;
    data['is_fav'] = this.isFav;
    return data;
  }
}