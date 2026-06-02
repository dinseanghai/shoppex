class ListSlideResponse {
  String? status;
  int? statusCode;
  List<Data>? data;

  ListSlideResponse({this.status, this.statusCode, this.data});

  ListSlideResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? subtitle;
  Null? description;
  String? imageUrl;
  int? sortOrder;

  Data(
      {this.id,
        this.title,
        this.subtitle,
        this.description,
        this.imageUrl,
        this.sortOrder});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    imageUrl = json['image_url'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}
