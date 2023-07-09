class HomePageBannerModel {
  int? success;
  List<Data>? data;
  String? message;

  HomePageBannerModel({this.success, this.data, this.message});

  HomePageBannerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? banner;
  String? serviceId;
  String? serviceName;
  int? price;
  String? loginUserId;
  String? categoryId;
  String? image;
  int? isActive;
  String? createdAt;
  Null? updatedAt;
  String? vendorName;
  int? like;
  String? catImage;
  String? rate;
  int? rateCount;
  String? currentMonth;

  Data(
      {this.banner,
      this.serviceId,
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
      this.rateCount,
      this.currentMonth});

  Data.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
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
    currentMonth = json['current_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner'] = this.banner;
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
    data['current_month'] = this.currentMonth;
    return data;
  }
}
