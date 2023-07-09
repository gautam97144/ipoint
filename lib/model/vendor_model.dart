class VendorDetailModel {
  int? success;
  VendorData? data;
  String? message;

  VendorDetailModel({this.success, this.data, this.message});

  VendorDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new VendorData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class VendorData {
  String? vendorId;
  String? description;
  String? vendorName;
  List<Banners>? banners;
  List<Services>? services;
  String? priceRange;
  String? rate;
  int? rateCount;
  int? like;
  int? likeCount;
  int? visitsCount;
  String? catImage;
  String? categoryName;

  VendorData(
      {this.vendorId,
      this.description,
      this.vendorName,
      this.banners,
      this.services,
      this.priceRange,
      this.rate,
      this.like,
      this.rateCount,
      this.likeCount,
      this.visitsCount,
      this.catImage,
      this.categoryName});

  VendorData.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    description = json['description'];
    vendorName = json['vendor_name'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    priceRange = json['price_range'].toString();
    rate = json['rate'];
    like = json['like'];
    likeCount = json['like_count'];
    rateCount = json['rate_count'];
    visitsCount = json['visits_count'];
    catImage = json['cat_image'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['description'] = this.description;
    data['vendor_name'] = this.vendorName;
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['price_range'] = this.priceRange;
    data['rate'] = this.rate;
    data['like'] = this.like;
    data['like_count'] = this.likeCount;
    data['rate_count'] = this.rateCount;
    data['visits_count'] = this.visitsCount;
    data['cat_image'] = this.catImage;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class Banners {
  String? bannerId;
  String? image;

  Banners({this.bannerId, this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['image'] = this.image;
    return data;
  }
}

class Services {
  String? serviceId;
  String? serviceName;
  String? price;
  String? loginUserId;
  String? categoryId;
  String? image;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  bool? isSelected = false;

  Services(
      {this.serviceId,
      this.serviceName,
      this.price,
      this.loginUserId,
      this.categoryId,
      this.image,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.isSelected});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    price = json['price'];
    loginUserId = json['login_user_id'];
    categoryId = json['category_id'];
    image = json['image'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSelected = json["isSelected"];
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
    data['isSelected'] = this.isSelected;
    return data;
  }
}
