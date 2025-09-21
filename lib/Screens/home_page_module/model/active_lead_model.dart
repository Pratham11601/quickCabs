// To parse this JSON data, do
//
//     final activeLeadModel = activeLeadModelFromJson(jsonString);

import 'dart:convert';

ActiveLeadModel activeLeadModelFromJson(String str) => ActiveLeadModel.fromJson(json.decode(str));

String activeLeadModelToJson(ActiveLeadModel data) => json.encode(data.toJson());

class ActiveLeadModel {
  bool? status;
  String? message;
  int? totalItems;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  bool? isNext;
  bool? isPrev;
  List<Post> posts;

  ActiveLeadModel({
    this.status,
    this.message,
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.isNext,
    this.isPrev,
    required this.posts,
  });

  factory ActiveLeadModel.fromJson(Map<String, dynamic> json) => ActiveLeadModel(
    status: json["status"],
    message: json["message"],
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    pageSize: json["pageSize"],
    isNext: json["isNext"],
    isPrev: json["isPrev"],
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "pageSize": pageSize,
    "isNext": isNext,
    "isPrev": isPrev,
    "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
  };
}

class Post {
  int? id;
  String? date;
  int? vendorId;
  String? vendorName;
  String? locationFrom;
  String? locationFromArea;
  String? carModel;
  String? addOn;
  String? fare;
  String? toLocation;
  String? toLocationArea;
  String? leadStatus;
  String? time;
  int? isActive;
  String? vendorContact;
  VendorCat? vendorCat;
  DateTime createdAt;
  DateTime updatedAt;
  int? tripType;
  dynamic acceptedById;
  String? otp;
  String? vendorFullname;
  String? vendorEmail;
  String? vendorCity;
  String? profileImgUrl;

  Post({
    this.id,
    this.date,
    this.vendorId,
    this.vendorName,
    this.locationFrom,
    this.locationFromArea,
    this.carModel,
    this.addOn,
    this.leadStatus,
    this.fare,
    this.toLocation,
    this.toLocationArea,
    this.time,
    this.isActive,
    this.vendorContact,
    this.vendorCat,
    required this.createdAt,
    required this.updatedAt,
    this.tripType,
    this.acceptedById,
    this.otp,
    this.vendorFullname,
    this.vendorEmail,
    this.vendorCity,
    this.profileImgUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    date: json["date"],
    vendorId: json["vendor_id"],
    vendorName: json["vendor_name"],
    locationFrom: json["location_from"],
    locationFromArea: json["location_from_area"],
    carModel: json["car_model"],
    addOn: json["add_on"],
    fare: json["fare"],
    toLocation: json["to_location"],
    toLocationArea: json["to_location_area"],
    time: json["time"],
    isActive: json["is_active"],
    leadStatus: json["lead_status"],
    vendorContact: json["vendor_contact"],
    vendorCat: vendorCatValues.map[json["vendor_cat"]],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    tripType: json["trip_type"],
    acceptedById: json["acceptedById"],
    otp: json["otp"],
    vendorFullname: json["vendor_fullname"],
    vendorEmail: json["vendor_email"],
    vendorCity: json["vendor_city"],
    profileImgUrl: json["profileImgUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "vendor_id": vendorId,
    "vendor_name": vendorName,
    "location_from": locationFrom,
    "location_from_area": locationFromArea,
    "car_model": carModel,
    "add_on": addOn,
    "fare": fare,
    "to_location": toLocation,
    "to_location_area": toLocationArea,
    "time": time,
    "is_active": isActive,
    "lead_status": leadStatus,
    "vendor_contact": vendorContact,
    "vendor_cat": vendorCatValues.reverse[vendorCat],
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "trip_type": tripType,
    "acceptedById": acceptedById,
    "otp": otp,
    "vendor_fullname": vendorFullname,
    "vendor_email": vendorEmail,
    "vendor_city": vendorCity,
    "profileImgUrl": profileImgUrl,
  };
}

enum VendorCat {
  CAB
}

final vendorCatValues = EnumValues({
  "Cab": VendorCat.CAB
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
