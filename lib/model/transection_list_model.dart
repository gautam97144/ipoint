class TransactionList {
  int? success;
  List<Data>? data;
  String? message;

  TransactionList({this.success, this.data, this.message});

  TransactionList.fromJson(Map<String, dynamic> json) {
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
  String? storeName;
  String? amount;
  String? transactionDate;
  String? description;
  int? paymentType;

  Data(
      {this.storeName,
      this.amount,
      this.transactionDate,
      this.description,
      this.paymentType});

  Data.fromJson(Map<String, dynamic> json) {
    storeName = json['store_name'];
    amount = json['amount'];
    transactionDate = json['transaction_date'];
    description = json['description'];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_name'] = this.storeName;
    data['amount'] = this.amount;
    data['transaction_date'] = this.transactionDate;
    data['description'] = this.description;
    data['payment_type'] = this.paymentType;
    return data;
  }
}
