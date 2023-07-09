class ServiceTenKm {
  int? success;
  Data? data;
  String? message;

  ServiceTenKm({this.success, this.data, this.message});

  ServiceTenKm.fromJson(Map<String, dynamic> json) {
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
  List<ServicesWithin10kmFromYou>? servicesWithin10kmFromYou;

  Data({this.servicesWithin10kmFromYou});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (this.servicesWithin10kmFromYou != null) {
      data['services_within_10km_from_you'] =
          this.servicesWithin10kmFromYou!.map((v) => v.toJson()).toList();
    }
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
      this.rateCount});

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
    return data;
  }
}
