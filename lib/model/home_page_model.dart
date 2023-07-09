class HomePage {
  int? success;
  Data? data;
  String? message;

  HomePage({this.success, this.data, this.message});

  HomePage.fromJson(Map<String, dynamic> json) {
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
  List<Top20ServicesThisMonth>? top20ServicesThisMonth;
  List<PeoplesFavourite>? peoplesFavourite;
  List<ServicesWithin10kmFromYou>? servicesWithin10kmFromYou;

  Data(
      {this.top20ServicesThisMonth,
      this.peoplesFavourite,
      this.servicesWithin10kmFromYou});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['top_20_services_this_month'] != null) {
      top20ServicesThisMonth = <Top20ServicesThisMonth>[];
      json['top_20_services_this_month'].forEach((v) {
        top20ServicesThisMonth!.add(new Top20ServicesThisMonth.fromJson(v));
      });
    }
    if (json['peoples_favourite'] != null) {
      peoplesFavourite = <PeoplesFavourite>[];
      json['peoples_favourite'].forEach((v) {
        peoplesFavourite!.add(new PeoplesFavourite.fromJson(v));
      });
    }
    if (json['services_within_10km_from_you'] != null) {
      servicesWithin10kmFromYou = <ServicesWithin10kmFromYou>[];
      json['services_within_10km_from_you'].forEach((v) {
        servicesWithin10kmFromYou!
            .add(new ServicesWithin10kmFromYou.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.top20ServicesThisMonth != null) {
      data['top_20_services_this_month'] =
          this.top20ServicesThisMonth!.map((v) => v.toJson()).toList();
    }
    if (this.peoplesFavourite != null) {
      data['peoples_favourite'] =
          this.peoplesFavourite!.map((v) => v.toJson()).toList();
    }
    if (this.servicesWithin10kmFromYou != null) {
      data['services_within_10km_from_you'] =
          this.servicesWithin10kmFromYou!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Top20ServicesThisMonth {
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
  int? visitsCnt;
  int? like;
  String? rate;
  int? rateCount;
  String? catImage;

  Top20ServicesThisMonth(
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
      this.visitsCnt,
      this.like,
      this.rate,
      this.rateCount,
      this.catImage});

  Top20ServicesThisMonth.fromJson(Map<String, dynamic> json) {
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
    visitsCnt = json['visits_cnt'];
    like = json['like'];
    rate = json['rate'];
    rateCount = json['rate_count'];
    catImage = json['cat_image'];
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
    data['visits_cnt'] = this.visitsCnt;
    data['like'] = this.like;
    data['rate'] = this.rate;
    data['rate_count'] = this.rateCount;
    data['cat_image'] = this.catImage;
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
  String? catImage;

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
      this.rateCount,
      this.catImage});

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
    catImage = json['cat_image'];
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
    data['cat_image'] = this.catImage;
    return data;
  }
}

class ServicesWithin10kmFromYou {
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
  int? appointmentServiceCnt;
  int? like;
  String? rate;
  int? rateCount;
  String? catImage;

  ServicesWithin10kmFromYou(
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
      this.appointmentServiceCnt,
      this.like,
      this.rate,
      this.rateCount,
      this.catImage});

  ServicesWithin10kmFromYou.fromJson(Map<String, dynamic> json) {
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
    appointmentServiceCnt = json['appointment_service_cnt'];
    like = json['like'];
    rate = json['rate'];
    rateCount = json['rate_count'];
    catImage = json['cat_image'];
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
    data['appointment_service_cnt'] = this.appointmentServiceCnt;
    data['like'] = this.like;
    data['rate'] = this.rate;
    data['rate_count'] = this.rateCount;
    data['cat_image'] = this.catImage;
    return data;
  }
}
