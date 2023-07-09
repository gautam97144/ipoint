class ReferralList {
  int? success;
  List<Data>? data;
  String? message;

  ReferralList({this.success, this.data, this.message});

  ReferralList.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? namePrefix;
  String? name;
  String? type;
  String? profile;
  String? dob;
  String? location;
  String? latitude;
  String? longitude;
  String? email;
  String? mobile;
  String? username;
  String? icNumber;
  Null? deviceId;
  String? apiToken;
  String? refreshToken;
  String? tokenCreatedAt;
  String? expiredAt;
  int? isActive;
  String? otp;
  String? ipointWallet;
  String? refCode;
  int? isBlock;
  Null? agentVendorId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? refDate;

  Data(
      {this.id,
      this.namePrefix,
      this.name,
      this.type,
      this.profile,
      this.dob,
      this.location,
      this.latitude,
      this.longitude,
      this.email,
      this.mobile,
      this.username,
      this.icNumber,
      this.deviceId,
      this.apiToken,
      this.refreshToken,
      this.tokenCreatedAt,
      this.expiredAt,
      this.isActive,
      this.otp,
      this.ipointWallet,
      this.refCode,
      this.isBlock,
      this.agentVendorId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.refDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namePrefix = json['name_prefix'];
    name = json['name'];
    type = json['type'];
    profile = json['profile'];
    dob = json['dob'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    email = json['email'];
    mobile = json['mobile'];
    username = json['username'];
    icNumber = json['ic_number'];
    deviceId = json['device_id'];
    apiToken = json['api_token'];
    refreshToken = json['refresh_token'];
    tokenCreatedAt = json['token_created_at'];
    expiredAt = json['expired_at'];
    isActive = json['is_active'];
    otp = json['otp'];
    ipointWallet = json['ipoint_wallet'];
    refCode = json['ref_code'];
    isBlock = json['is_block'];
    agentVendorId = json['agent_vendor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    refDate = json['ref_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_prefix'] = this.namePrefix;
    data['name'] = this.name;
    data['type'] = this.type;
    data['profile'] = this.profile;
    data['dob'] = this.dob;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['username'] = this.username;
    data['ic_number'] = this.icNumber;
    data['device_id'] = this.deviceId;
    data['api_token'] = this.apiToken;
    data['refresh_token'] = this.refreshToken;
    data['token_created_at'] = this.tokenCreatedAt;
    data['expired_at'] = this.expiredAt;
    data['is_active'] = this.isActive;
    data['otp'] = this.otp;
    data['ipoint_wallet'] = this.ipointWallet;
    data['ref_code'] = this.refCode;
    data['is_block'] = this.isBlock;
    data['agent_vendor_id'] = this.agentVendorId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['ref_date'] = this.refDate;
    return data;
  }
}
