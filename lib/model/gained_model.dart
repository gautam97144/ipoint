class GainedModel {
  int? success;
  List<Data>? data;
  String? message;

  GainedModel({this.success, this.data, this.message});

  GainedModel.fromJson(Map<String, dynamic> json) {
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
  String? points;
  String? name;
  String? description;
  String? createdAt;

  String? transactionDate;

  Data(
      {this.points,
      this.name,
      this.description,
      this.transactionDate,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    points = json['points'];
    name = json['name'];
    description = json['description'];
    transactionDate = json['transaction_date'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    data['name'] = this.name;
    data['description'] = this.description;
    data['transaction_date'] = this.transactionDate;
    data['created_at'] = this.createdAt;

    return data;
  }
}
