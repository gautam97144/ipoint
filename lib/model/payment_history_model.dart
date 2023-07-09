class PaymentHistory {
  int? success;
  List<PaymentData>? data;
  String? message;

  PaymentHistory({this.success, this.data, this.message});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <PaymentData>[];
      json['data'].forEach((v) {
        data!.add(new PaymentData.fromJson(v));
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

class PaymentData {
  String? appointmentId;
  String? userId;
  String? vendorId;
  String? appointmentNo;
  String? name;
  String? contactNo;
  String? vehicleNo;
  int? statusId;
  int? issueBill;
  String? appointmentDate;
  String? appointmentTime;
  String? amount;
  String? createdAt;
  String? updatedAt;
  String? servicesName;
  String? servicesPrice;
  String? servicesImages;
  String? payInvoiceAmount;
  String? payCreatedAt;
  int? paymentType;
  String? vendorName;

  PaymentData(
      {this.appointmentId,
      this.userId,
      this.vendorId,
      this.appointmentNo,
      this.name,
      this.contactNo,
      this.vehicleNo,
      this.statusId,
      this.issueBill,
      this.appointmentDate,
      this.appointmentTime,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.servicesName,
      this.servicesPrice,
      this.servicesImages,
      this.payInvoiceAmount,
      this.payCreatedAt,
      this.paymentType,
      this.vendorName});

  PaymentData.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    appointmentNo = json['appointment_no'];
    name = json['name'];
    contactNo = json['contact_no'];
    vehicleNo = json['vehicle_no'];
    statusId = json['status_id'];
    issueBill = json['issue_bill'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    servicesName = json['services_name'];
    servicesPrice = json['services_price'];
    servicesImages = json['services_images'];
    payInvoiceAmount = json['pay_invoice_amount'];
    payCreatedAt = json['pay_created_at'];
    paymentType = json['payment_type'];
    vendorName = json['vendor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['appointment_no'] = this.appointmentNo;
    data['name'] = this.name;
    data['contact_no'] = this.contactNo;
    data['vehicle_no'] = this.vehicleNo;
    data['status_id'] = this.statusId;
    data['issue_bill'] = this.issueBill;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['services_name'] = this.servicesName;
    data['services_price'] = this.servicesPrice;
    data['services_images'] = this.servicesImages;
    data['pay_invoice_amount'] = this.payInvoiceAmount;
    data['pay_created_at'] = this.payCreatedAt;
    data['payment_type'] = this.paymentType;
    data['vendor_name'] = this.vendorName;

    return data;
  }
}
