class DriverAvailabilityModel {
  int? status;
  String? message;
  Data? data;

  DriverAvailabilityModel({this.status, this.message, this.data});

  DriverAvailabilityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? status;
  int? id;
  String? car;
  String? location;
  String? fromDate;
  String? fromTime;
  String? toDate;
  String? toTime;
  String? phone;
  String? name;
  int? userId;
  String? updatedAt;
  String? createdAt;

  Data(
      {this.status,
      this.id,
      this.car,
      this.location,
      this.fromDate,
      this.fromTime,
      this.toDate,
      this.toTime,
      this.phone,
      this.name,
      this.userId,
      this.updatedAt,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    id = json['id'];
    car = json['car'];
    location = json['location'];
    fromDate = json['from_date'];
    fromTime = json['from_time'];
    toDate = json['to_date'];
    toTime = json['to_time'];
    phone = json['phone'];
    name = json['name'];
    userId = json['userId'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['id'] = this.id;
    data['car'] = this.car;
    data['location'] = this.location;
    data['from_date'] = this.fromDate;
    data['from_time'] = this.fromTime;
    data['to_date'] = this.toDate;
    data['to_time'] = this.toTime;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
