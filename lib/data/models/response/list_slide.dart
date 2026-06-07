class SlideShow {
  String? status;
  int? statusCode;
  List<SlideData>? data;

  SlideShow({this.status, this.statusCode, this.data});

  SlideShow.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <SlideData>[];
      json['data'].forEach((v) {
        data!.add(SlideData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlideData {
  int? id;
  String? title;
  String? subtitle;
  String? description;
  String? imageUrl;
  int? sortOrder;
  String? status;

  SlideData({this.id, this.title, this.subtitle, this.description, this.imageUrl, this.sortOrder, this.status});

  SlideData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    imageUrl = json['image_url'];
    sortOrder = json['sort_order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['sort_order'] = sortOrder;
    data['status'] = status;
    return data;
  }
}