class HelpCenterModel {
  int? success;
  Data? data;
  String? message;

  HelpCenterModel({this.success, this.data, this.message});

  HelpCenterModel.fromJson(Map<String, dynamic> json) {
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
  String? helpCenterId;
  String? userId;
  String? message;
  int? status;
  String? createdAt;

  Data(
      {this.helpCenterId,
      this.userId,
      this.message,
      this.status,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    helpCenterId = json['help_center_id'];
    userId = json['user_id'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['help_center_id'] = this.helpCenterId;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
