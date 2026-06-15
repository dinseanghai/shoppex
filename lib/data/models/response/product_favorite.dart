class ProductFavorite {
  String? status;
  int? statusCode;
  String? message;
  bool? isFavorite;

  ProductFavorite(
      {this.status, this.statusCode, this.message, this.isFavorite});

  ProductFavorite.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}
