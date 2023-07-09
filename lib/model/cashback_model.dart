class CashbackModel {
  int? success;
  List<Data>? data;
  String? message;

  CashbackModel({this.success, this.data, this.message});

  CashbackModel.fromJson(Map<String, dynamic> json) {
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
  int? pointsId;
  String? userId;
  String? transactionId;
  String? points;
  String? message;
  int? type;
  int? isAdmin;
  int? isCashback;
  String? description;
  String? createdAt;

  Data(
      {this.pointsId,
      this.userId,
      this.transactionId,
      this.points,
      this.message,
      this.type,
      this.isAdmin,
      this.isCashback,
      this.description,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    pointsId = json['points_id'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    points = json['points'];
    message = json['message'];
    type = json['type'];
    isAdmin = json['is_admin'];
    isCashback = json['is_cashback'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points_id'] = this.pointsId;
    data['user_id'] = this.userId;
    data['transaction_id'] = this.transactionId;
    data['points'] = this.points;
    data['message'] = this.message;
    data['type'] = this.type;
    data['is_admin'] = this.isAdmin;
    data['is_cashback'] = this.isCashback;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    return data;
  }
}
