class ServiceRatingModel {
  int? success;
  Data? data;
  String? message;

  ServiceRatingModel({this.success, this.data, this.message});

  ServiceRatingModel.fromJson(Map<String, dynamic> json) {
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
  String? serviceRatingId;
  String? userId;
  String? vendorId;
  String? rate;
  String? createdAt;
  int? id;

  Data(
      {this.serviceRatingId,
      this.userId,
      this.vendorId,
      this.rate,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    serviceRatingId = json['service_rating_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    rate = json['rate'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_rating_id'] = this.serviceRatingId;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['rate'] = this.rate;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
