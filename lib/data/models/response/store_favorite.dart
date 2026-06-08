class StoreFavorite {
  String? status;
  int? statusCode;
  String? message;
  bool? isFav;

  StoreFavorite({this.status, this.statusCode, this.message, this.isFav});

  StoreFavorite.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['is_fav'] = this.isFav;
    return data;
  }
}
