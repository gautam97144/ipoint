class InvoicePayModel {
  int? success;
  Data? data;
  String? message;

  InvoicePayModel({this.success, this.data, this.message});

  InvoicePayModel.fromJson(Map<String, dynamic> json) {
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
  String? transactionId;
  String? userId;
  String? appointmentId;
  String? description;
  String? amount;
  int? status;
  String? createdAt;
  String? ipointWallet;

  Data(
      {this.transactionId,
      this.userId,
      this.appointmentId,
      this.description,
      this.amount,
      this.status,
      this.createdAt,
      this.ipointWallet});

  Data.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    userId = json['user_id'];
    appointmentId = json['appointment_id'];
    description = json['description'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    ipointWallet = json['ipoint_wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['user_id'] = this.userId;
    data['appointment_id'] = this.appointmentId;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['ipoint_wallet'] = this.ipointWallet;
    return data;
  }
}
