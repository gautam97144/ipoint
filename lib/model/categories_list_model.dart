class CategoryList {
  int? success;
  List<AllCategory>? data;
  String? message;

  CategoryList({this.success, this.data, this.message});

  CategoryList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AllCategory>[];
      json['data'].forEach((v) {
        data!.add(new AllCategory.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AllCategory {
  String? categoryId;
  String? categoryName;
  String? image;

  AllCategory({this.categoryId, this.categoryName, this.image});

  AllCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    return data;
  }
}
