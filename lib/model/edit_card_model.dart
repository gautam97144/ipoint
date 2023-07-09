class EditCardModel {
  int? success;
  EditCardData? data;
  String? message;

  EditCardModel({this.success, this.data, this.message});

  EditCardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
        json['data'] != null ? new EditCardData.fromJson(json['data']) : null;
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

class EditCardData {
  String? cardId;
  String? userId;
  String? name;
  String? cardNo;
  String? month;
  String? year;
  int? status;
  String? createdAt;

  EditCardData(
      {this.cardId,
      this.userId,
      this.name,
      this.cardNo,
      this.month,
      this.year,
      this.status,
      this.createdAt});

  EditCardData.fromJson(Map<String, dynamic> json) {
    cardId = json['card_id'];
    userId = json['user_id'];
    name = json['name'];
    cardNo = json['card_no'];
    month = json['month'];
    year = json['year'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_id'] = this.cardId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['card_no'] = this.cardNo;
    data['month'] = this.month;
    data['year'] = this.year;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}
