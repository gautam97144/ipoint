class Payment {
  String? status;
  List<Result>? result;
  String? message;

  Payment({this.status, this.result, this.message});

  Payment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Result {
  String? status;
  String? key;
  String? url;
  Null? error;

  Result({this.status, this.key, this.url, this.error});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    key = json['key'];
    url = json['url'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['key'] = this.key;
    data['url'] = this.url;
    data['error'] = this.error;
    return data;
  }
}
