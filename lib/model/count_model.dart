class Count {
  int? success;
  Data? data;
  String? message;

  Count({this.success, this.data, this.message});

  Count.fromJson(Map<String, dynamic> json) {
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
  int? appointmentCount;
  int? favoriteCount;

  Data({this.appointmentCount, this.favoriteCount});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentCount = json['appointment_count'];
    favoriteCount = json['favorite_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_count'] = this.appointmentCount;
    data['favorite_count'] = this.favoriteCount;
    return data;
  }
}
