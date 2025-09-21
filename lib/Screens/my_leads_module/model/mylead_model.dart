import 'dart:convert';

MyLeadModel myleadModelFromJson(String str) =>
    MyLeadModel.fromJson(json.decode(str));

String myleadModelToJson(MyLeadModel data) => json.encode(data.toJson());

class MyLeadModel {
  bool? status;
  String? message;
  int? totalItems;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  bool? isNext;
  bool? isPrev;
  List<Lead> leads;

  MyLeadModel({
    this.status,
    this.message,
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.isNext,
    this.isPrev,
    required this.leads,
  });

  factory MyLeadModel.fromJson(Map<String, dynamic> json) => MyLeadModel(
        status: json["status"],
        message: json["message"],
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        isNext: json["isNext"],
        isPrev: json["isPrev"],
        leads: List<Lead>.from(json["leads"].map((x) => Lead.fromJson(x))),
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
        "leads": List<dynamic>.from(leads.map((x) => x.toJson())),
      };
}

class Lead {
  int? id;
  DateTime date;
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
  String? leadStatus;

  String? vendorContact;
  String? vendorCat;
  String? otp;
  dynamic acceptedById;
  DateTime createdAt;
  DateTime updatedAt;

  Lead({
    this.id,
    required this.date,
    this.vendorId,
    this.vendorName,
    this.locationFrom,
    this.locationFromArea,
    this.toLocation,
    this.toLocationArea,
    this.carModel,
    this.addOn,
    this.leadStatus,
    this.fare,
    this.time,
    this.isActive,
    this.vendorContact,
    this.vendorCat,
    this.otp,
    this.acceptedById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        locationFrom: json["location_from"],
        locationFromArea: json["location_from_area"],
        toLocation: json["to_location"],
        toLocationArea: json["to_location_area"],
        carModel: json["car_model"],
        leadStatus: json["lead_status"],
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
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "location_from": locationFrom,
        "location_from_area": locationFromArea,
        "to_location": toLocation,
        "to_location_area": toLocationArea,
        "car_model": carModel,
        "lead_status": leadStatus,
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
}
