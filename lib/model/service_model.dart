class ServiceModel {
  int? success;
  List<ServiceData>? data;
  String? message;
  Category? category;

  ServiceModel({this.success, this.data, this.message, this.category});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data!.add(new ServiceData.fromJson(v));
      });
    }
    message = json['message'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class ServiceData {
  String? serviceId;
  String? serviceName;
  String? price;
  String? loginUserId;
  String? categoryId;
  String? image;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? vendorName;
  int? like;
  String? catImage;
  String? rate;
  int? rateCount;

  ServiceData(
      {this.serviceId,
      this.serviceName,
      this.price,
      this.loginUserId,
      this.categoryId,
      this.image,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.vendorName,
      this.like,
      this.catImage,
      this.rate,
      this.rateCount});

  ServiceData.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    price = json['price'];
    loginUserId = json['login_user_id'];
    categoryId = json['category_id'];
    image = json['image'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendorName = json['vendor_name'];
    like = json['like'];
    catImage = json['cat_image'];
    rate = json['rate'];
    rateCount = json['rate_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    data['login_user_id'] = this.loginUserId;
    data['category_id'] = this.categoryId;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['vendor_name'] = this.vendorName;
    data['like'] = this.like;
    data['cat_image'] = this.catImage;
    data['rate'] = this.rate;
    data['rate_count'] = this.rateCount;
    return data;
  }
}

class Category {
  String? catImage;
  String? categoryName;

  Category({this.catImage, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    catImage = json['cat_image'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_image'] = this.catImage;
    data['category_name'] = this.categoryName;
    return data;
  }
}
