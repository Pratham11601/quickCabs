class ProfileDetailsModel {
  bool? status;
  Vendor? vendor;

  ProfileDetailsModel({this.status, this.vendor});

  ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendor = json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? id;
  String? fullname;
  String? phone;
  String? aadhaarNumber;
  String? email;
  String? password;
  int? status;
  int? isVerified;
  String? businessName;
  String? city;
  String? vendorCat;
  String? profileImgUrl;
  Null? vehicleImgUrl;
  Null? shopImgUrl;
  String? documentImgUrl;
  String? licenseImgUrl;
  String? currentAddress;
  String? pinCode;
  Null? carnumber;
  Null? subscriptionPlan;
  Null? subscriptionDate;
  Null? subEndDate;
  String? vendorGender;
  String? fcmToken;
  Null? referredBy;
  String? createdAt;
  String? updatedAt;

  Vendor(
      {this.id,
      this.fullname,
      this.phone,
      this.aadhaarNumber,
      this.email,
      this.password,
      this.status,
      this.isVerified,
      this.businessName,
      this.city,
      this.vendorCat,
      this.profileImgUrl,
      this.vehicleImgUrl,
      this.shopImgUrl,
      this.documentImgUrl,
      this.licenseImgUrl,
      this.currentAddress,
      this.pinCode,
      this.carnumber,
      this.subscriptionPlan,
      this.subscriptionDate,
      this.subEndDate,
      this.vendorGender,
      this.fcmToken,
      this.referredBy,
      this.createdAt,
      this.updatedAt});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    phone = json['phone'];
    aadhaarNumber = json['aadhaar_number'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    isVerified = json['isVerified'];
    businessName = json['businessName'];
    city = json['city'];
    vendorCat = json['vendor_cat'];
    profileImgUrl = json['profileImgUrl'];
    vehicleImgUrl = json['vehicleImgUrl'];
    shopImgUrl = json['shopImgUrl'];
    documentImgUrl = json['documentImgUrl'];
    licenseImgUrl = json['licenseImgUrl'];
    currentAddress = json['currentAddress'];
    pinCode = json['pin_code'];
    carnumber = json['carnumber'];
    subscriptionPlan = json['subscriptionPlan'];
    subscriptionDate = json['subscription_date'];
    subEndDate = json['sub_end_date'];
    vendorGender = json['vendor_gender'];
    fcmToken = json['fcmToken'];
    referredBy = json['referred_by'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['phone'] = this.phone;
    data['aadhaar_number'] = this.aadhaarNumber;
    data['email'] = this.email;
    data['password'] = this.password;
    data['status'] = this.status;
    data['isVerified'] = this.isVerified;
    data['businessName'] = this.businessName;
    data['city'] = this.city;
    data['vendor_cat'] = this.vendorCat;
    data['profileImgUrl'] = this.profileImgUrl;
    data['vehicleImgUrl'] = this.vehicleImgUrl;
    data['shopImgUrl'] = this.shopImgUrl;
    data['documentImgUrl'] = this.documentImgUrl;
    data['licenseImgUrl'] = this.licenseImgUrl;
    data['currentAddress'] = this.currentAddress;
    data['pin_code'] = this.pinCode;
    data['carnumber'] = this.carnumber;
    data['subscriptionPlan'] = this.subscriptionPlan;
    data['subscription_date'] = this.subscriptionDate;
    data['sub_end_date'] = this.subEndDate;
    data['vendor_gender'] = this.vendorGender;
    data['fcmToken'] = this.fcmToken;
    data['referred_by'] = this.referredBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
