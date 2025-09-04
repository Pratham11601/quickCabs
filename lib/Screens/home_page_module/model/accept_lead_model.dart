// To parse this JSON data, do
//
//     final acceptLeadModel = acceptLeadModelFromJson(jsonString);

import 'dart:convert';

AcceptLeadModel acceptLeadModelFromJson(String str) => AcceptLeadModel.fromJson(json.decode(str));

String acceptLeadModelToJson(AcceptLeadModel data) => json.encode(data.toJson());

class AcceptLeadModel {
  int? status;
  String? message;
  Lead lead;

  AcceptLeadModel({
    this.status,
    this.message,
    required this.lead,
  });

  factory AcceptLeadModel.fromJson(Map<String, dynamic> json) => AcceptLeadModel(
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
  DateTime? date;
  int? vendorId;
  String? vendorName;
  String? locationFrom;
  String? locationFromArea;
  String? toLocation;
  String? toLocationArea;
  String? carModel;
  String? addOn;
  String? fare;
  String? time;
  bool? isActive;
  String? vendorContact;
  String? vendorCat;
  String? otp;
  int acceptedById;
  DateTime createdAt;
  DateTime updatedAt;

  Lead({
    this.id,
    this.date,
    this.vendorId,
    this.vendorName,
    this.locationFrom,
    this.locationFromArea,
    this.toLocation,
    this.toLocationArea,
    this.carModel,
    this.addOn,
    this.fare,
    this.time,
    this.isActive,
    this.vendorContact,
    this.vendorCat,
    this.otp,
    required this.acceptedById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    id: json["id"],
    date: _parseCustomDate(json["date"]),
    vendorId: json["vendor_id"],
    vendorName: json["vendor_name"],
    locationFrom: json["location_from"],
    locationFromArea: json["location_from_area"],
    toLocation: json["to_location"],
    toLocationArea: json["to_location_area"],
    carModel: json["car_model"],
    addOn: json["add_on"],
    fare: json["fare"],
    time: json["time"],
    isActive: json["is_active"],
    vendorContact: json["vendor_contact"],
    vendorCat: json["vendor_cat"],
    otp: json["otp"],
    acceptedById: json["acceptedById"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date != null
        ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
        : null,
    "vendor_id": vendorId,
    "vendor_name": vendorName,
    "location_from": locationFrom,
    "location_from_area": locationFromArea,
    "to_location": toLocation,
    "to_location_area": toLocationArea,
    "car_model": carModel,
    "add_on": addOn,
    "fare": fare,
    "time": time,
    "is_active": isActive,
    "vendor_contact": vendorContact,
    "vendor_cat": vendorCat,
    "otp": otp,
    "acceptedById": acceptedById,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  static DateTime? _parseCustomDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}
