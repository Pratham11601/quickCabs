import 'dart:convert';

RefreshFcmModel refreshFcmModelFromJson(String str) =>
    RefreshFcmModel.fromJson(json.decode(str));

String refreshFcmModelToJson(RefreshFcmModel data) =>
    json.encode(data.toJson());

class RefreshFcmModel {
  final String message;
  final int status;

  RefreshFcmModel({
    required this.message,
    required this.status,
  });

  factory RefreshFcmModel.fromJson(Map<String, dynamic> json) {
    return RefreshFcmModel(
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
