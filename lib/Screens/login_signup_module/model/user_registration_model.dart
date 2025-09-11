// ignore_for_file: unnecessary_new

class UserRegistrationModel {
  bool? status = true;
  String? message;
  Vendor? vendor;

  UserRegistrationModel({this.message, this.vendor});

  UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
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
  String? referredBy;
  String? email;
  String? password;
  String? vendorCat;
  String? businessName;
  String? city;
  String? vendorGender;
  String? currentAddress;
  String? pinCode;
  String? carnumber;
  String? vehicleImgUrl;
  String? profileImgUrl;
  String? shopImgUrl;
  String? documentImgUrl;
  String? licenseImgUrl;
  String? updatedAt;
  String? createdAt;

  Vendor(
      {this.status,
      this.isVerified,
      this.id,
      this.fullname,
      this.phone,
      this.referredBy,
      this.email,
      this.password,
      this.vendorCat,
      this.businessName,
      this.city,
      this.vendorGender,
      this.currentAddress,
      this.pinCode,
      this.carnumber,
      this.vehicleImgUrl,
      this.profileImgUrl,
      this.shopImgUrl,
      this.documentImgUrl,
      this.licenseImgUrl,
      this.updatedAt,
      this.createdAt});

  Vendor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isVerified = json['isVerified'];
    id = json['id'];
    fullname = json['fullname'];
    phone = json['phone'];
    referredBy = json['referred_by'];
    email = json['email'];
    password = json['password'];
    vendorCat = json['vendor_cat'];
    businessName = json['businessName'];
    city = json['city'];
    vendorGender = json['vendor_gender'];
    currentAddress = json['currentAddress'];
    pinCode = json['pin_code'];
    carnumber = json['carnumber'];
    vehicleImgUrl = json['vehicleImgUrl'];
    profileImgUrl = json['profileImgUrl'];
    shopImgUrl = json['shopImgUrl'];
    documentImgUrl = json['documentImgUrl'];
    licenseImgUrl = json['licenseImgUrl'];
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
    data['referred_by'] = referredBy;
    data['email'] = email;
    data['password'] = password;
    data['vendor_cat'] = vendorCat;
    data['businessName'] = businessName;
    data['city'] = city;
    data['vendor_gender'] = vendorGender;
    data['currentAddress'] = currentAddress;
    data['pin_code'] = pinCode;
    data['carnumber'] = carnumber;
    data['vehicleImgUrl'] = vehicleImgUrl;
    data['profileImgUrl'] = profileImgUrl;
    data['shopImgUrl'] = shopImgUrl;
    data['documentImgUrl'] = documentImgUrl;
    data['licenseImgUrl'] = licenseImgUrl;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
