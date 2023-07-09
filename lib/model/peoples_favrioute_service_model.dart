class PeopleFavourite {
  int? success;
  Data? data;
  String? message;

  PeopleFavourite({this.success, this.data, this.message});

  PeopleFavourite.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<PeoplesFavourite>? peoplesFavourite;

  Data({this.peoplesFavourite});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['peoples_favourite'] != null) {
      peoplesFavourite = <PeoplesFavourite>[];
      json['peoples_favourite'].forEach((v) {
        peoplesFavourite!.add(new PeoplesFavourite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.peoplesFavourite != null) {
      data['peoples_favourite'] =
          this.peoplesFavourite!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PeoplesFavourite {
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
  int? favouriteCnt;
  int? like;
  String? rate;
  int? rateCount;

  PeoplesFavourite(
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
      this.favouriteCnt,
      this.like,
      this.rate,
      this.rateCount});

  PeoplesFavourite.fromJson(Map<String, dynamic> json) {
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
    favouriteCnt = json['favourite_cnt'];
    like = json['like'];
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
    data['favourite_cnt'] = this.favouriteCnt;
    data['like'] = this.like;
    data['rate'] = this.rate;
    data['rate_count'] = this.rateCount;
    return data;
  }
}
