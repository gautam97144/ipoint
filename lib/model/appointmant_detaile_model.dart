class AppointmentDetailModel {
  int? success;
  AppointmentDetailData? data;
  String? message;

  AppointmentDetailModel({this.success, this.data, this.message});

  AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new AppointmentDetailData.fromJson(json['data'])
        : null;
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

class AppointmentDetailData {
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
  String? description;
  String? storeName;
  String? companyName;
  String? vendorName;
  List<Services>? services;
  List<Banner>? banner;
  List<AdditionalCharges>? additionalCharges;
  String? catName;
  String? catImage;

  AppointmentDetailData(
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
      this.description,
      this.storeName,
      this.companyName,
      this.vendorName,
      this.services,
      this.banner,
      this.additionalCharges,
      this.catName,
      this.catImage});

  AppointmentDetailData.fromJson(Map<String, dynamic> json) {
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
    description = json['description'];
    storeName = json['store_name'];
    companyName = json['company_name'];
    vendorName = json['vendor_name'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(new Banner.fromJson(v));
      });
    }
    if (json['additional_charges'] != null) {
      additionalCharges = <AdditionalCharges>[];
      json['additional_charges'].forEach((v) {
        additionalCharges!.add(new AdditionalCharges.fromJson(v));
      });
    }
    catName = json['cat_name'];
    catImage = json['cat_image'];
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
    data['description'] = this.description;
    data['store_name'] = this.storeName;
    data['company_name'] = this.companyName;
    data['vendor_name'] = this.vendorName;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.additionalCharges != null) {
      data['additional_charges'] =
          this.additionalCharges!.map((v) => v.toJson()).toList();
    }
    data['cat_name'] = this.catName;
    data['cat_image'] = this.catImage;

    return data;
  }
}

class Services {
  String? serviceId;
  String? serviceName;
  String? price;
  int? isSelected;

  Services({this.serviceId, this.serviceName, this.price, this.isSelected});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    price = json['price'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    data['is_selected'] = this.isSelected;
    return data;
  }
}

class Banner {
  String? image;

  Banner({this.image});

  Banner.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class AdditionalCharges {
  int? additionalChargesId;
  String? name;
  String? price;

  AdditionalCharges({this.additionalChargesId, this.name, this.price});

  AdditionalCharges.fromJson(Map<String, dynamic> json) {
    additionalChargesId = json['additional_charges_id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['additional_charges_id'] = this.additionalChargesId;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
