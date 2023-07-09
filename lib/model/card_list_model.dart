class CardListModel {
  int? success;
  List<CardData>? data;
  String? message;

  CardListModel({this.success, this.data, this.message});

  CardListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CardData>[];
      json['data'].forEach((v) {
        data!.add(new CardData.fromJson(v));
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

class CardData {
  String? cardId;
  String? userId;
  String? name;
  String? cardNo;
  String? month;
  String? year;
  int? status;
  String? createdAt;

  CardData(
      {this.cardId,
      this.userId,
      this.name,
      this.cardNo,
      this.month,
      this.year,
      this.status,
      this.createdAt});

  CardData.fromJson(Map<String, dynamic> json) {
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
