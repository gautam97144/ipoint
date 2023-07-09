class GetAppointmentsModel {
  int? success;
  List<AppointmentData>? data;
  String? message;

  GetAppointmentsModel({this.success, this.data, this.message});

  GetAppointmentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AppointmentData>[];
      json['data'].forEach((v) {
        data!.add(new AppointmentData.fromJson(v));
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

class AppointmentData {
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
  String? vendorName;
  String? catImage;

  List<AdditionalCharge>? additionalCharge;

  AppointmentData(
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
      this.vendorName,
      this.catImage,
      this.additionalCharge});

  AppointmentData.fromJson(Map<String, dynamic> json) {
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
    vendorName = json['vendor_name'];
    catImage = json['cat_image'];

    if (json['additional_charge'] != null) {
      additionalCharge = <AdditionalCharge>[];
      json['additional_charge'].forEach((v) {
        additionalCharge!.add(new AdditionalCharge.fromJson(v));
      });
    }
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
    data['vendor_name'] = this.vendorName;
    data['cat_image'] = this.catImage;

    if (this.additionalCharge != null) {
      data['additional_charge'] =
          this.additionalCharge!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdditionalCharge {
  int? additionalChargesId;
  String? appointmentId;
  String? name;
  String? itemAmount;
  String? price;
  String? createdAt;

  AdditionalCharge(
      {this.additionalChargesId,
      this.appointmentId,
      this.name,
      this.itemAmount,
      this.price,
      this.createdAt});

  AdditionalCharge.fromJson(Map<String, dynamic> json) {
    additionalChargesId = json['additional_charges_id'];
    appointmentId = json['appointment_id'];
    name = json['name'];
    itemAmount = json['item_amount'];
    price = json['price'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['additional_charges_id'] = this.additionalChargesId;
    data['appointment_id'] = this.appointmentId;
    data['name'] = this.name;
    data['item_amount'] = this.itemAmount;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    return data;
  }
}
