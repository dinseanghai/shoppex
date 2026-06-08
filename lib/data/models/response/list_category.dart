class ListCategory {
  String? status;
  int? statusCode;
  List<CategoryData>? categoryData; // Fixed naming to camelCase

  ListCategory({this.status, this.statusCode, this.categoryData}); // Fixed constructor name

  ListCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      categoryData = <CategoryData>[]; // Fixed variable reference
      json['data'].forEach((v) {
        categoryData!.add(CategoryData.fromJson(v)); // Fixed variable reference and removed redundant 'new'
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    if (this.categoryData != null) { // Fixed variable reference
      data['data'] = this.categoryData!.map((v) => v.toJson()).toList(); // Fixed variable reference
    }
    return data;
  }
}

class CategoryData { // Fixed class name to match ListCategory's list type
  int? id;
  String? name;

  CategoryData({this.id, this.name}); // Fixed constructor name

  CategoryData.fromJson(Map<String, dynamic> json) { // Fixed factory constructor name
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}