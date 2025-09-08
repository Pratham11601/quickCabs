class UserRegistrationModel {
  bool? status;
  String? message;
  String? token;
  Vendor? vendor;

  UserRegistrationModel({this.status, this.message, this.token, this.vendor});

  UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? status;
  int? isVerified;
  int? id;
  String? fullname;
  String? phone;
  String? aadhaarNumber;
  String? password;
  String? vendorCat;
  String? vendorGender;
  String? updatedAt;
  String? createdAt;

  Vendor(
      {this.status,
      this.isVerified,
      this.id,
      this.fullname,
      this.phone,
      this.aadhaarNumber,
      this.password,
      this.vendorCat,
      this.vendorGender,
      this.updatedAt,
      this.createdAt});

  Vendor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isVerified = json['isVerified'];
    id = json['id'];
    fullname = json['fullname'];
    phone = json['phone'];
    aadhaarNumber = json['aadhaar_number'];
    password = json['password'];
    vendorCat = json['vendor_cat'];
    vendorGender = json['vendor_gender'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['isVerified'] = isVerified;
    data['id'] = id;
    data['fullname'] = fullname;
    data['phone'] = phone;
    data['aadhaar_number'] = aadhaarNumber;
    data['password'] = password;
    data['vendor_cat'] = vendorCat;
    data['vendor_gender'] = vendorGender;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
