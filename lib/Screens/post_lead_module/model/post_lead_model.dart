// To parse this JSON data, do
//
//     final postLeadModel = postLeadModelFromJson(jsonString);

import 'dart:convert';

PostLeadModel postLeadModelFromJson(String str) => PostLeadModel.fromJson(json.decode(str));

String postLeadModelToJson(PostLeadModel data) => json.encode(data.toJson());

class PostLeadModel {
  bool? status;
  String? message;
  Lead lead;

  PostLeadModel({
    this.status,
    this.message,
    required this.lead,
  });

  factory PostLeadModel.fromJson(Map<String, dynamic> json) => PostLeadModel(
    status: json["status"],
    message: json["message"],
    lead: Lead.fromJson(json["lead"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "lead": lead.toJson(),
  };
}

class Lead {
  int? id;
  String? vendorName;
  int? vendorId;
  String? vendorCat;
  String? vendorContact;
  DateTime date;
  String? time;
  String? locationFrom;
  String? locationFromArea;
  String? toLocation;
  String? toLocationArea;
  String? carModel;
  String? addOn;
  int? fare;
  int? otp;
  bool? isActive;
  DateTime updatedAt;
  DateTime createdAt;

  Lead({
    this.id,
    this.vendorName,
    this.vendorId,
    this.vendorCat,
    this.vendorContact,
    required this.date,
    this.time,
    this.locationFrom,
    this.locationFromArea,
    this.toLocation,
    this.toLocationArea,
    this.carModel,
    this.addOn,
    this.fare,
    this.otp,
    this.isActive,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    id: json["id"],
    vendorName: json["vendor_name"],
    vendorId: json["vendor_id"],
    vendorCat: json["vendor_cat"],
    vendorContact: json["vendor_contact"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
    locationFrom: json["location_from"],
    locationFromArea: json["location_from_area"],
    toLocation: json["to_location"],
    toLocationArea: json["to_location_area"],
    carModel: json["car_model"],
    addOn: json["add_on"],
    fare: json["fare"],
    otp: json["otp"],
    isActive: json["is_active"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_name": vendorName,
    "vendor_id": vendorId,
    "vendor_cat": vendorCat,
    "vendor_contact": vendorContact,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
    "location_from": locationFrom,
    "location_from_area": locationFromArea,
    "to_location": toLocation,
    "to_location_area": toLocationArea,
    "car_model": carModel,
    "add_on": addOn,
    "fare": fare,
    "otp": otp,
    "is_active": isActive,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };
}
