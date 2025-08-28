class ProfileDetailsModel {
  bool? status;
  Vendor? vendor;

  ProfileDetailsModel({this.status, this.vendor});

  ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
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
  String? documentImgUrl;
  String? licenseImgUrl;
  String? currentAddress;
  String? pinCode;
  String? carnumber;
  String? subscriptionPlan;
  String? subscriptionDate;
  String? subEndDate;
  String? vendorGender;
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
      this.documentImgUrl,
      this.licenseImgUrl,
      this.currentAddress,
      this.pinCode,
      this.carnumber,
      this.subscriptionPlan,
      this.subscriptionDate,
      this.subEndDate,
      this.vendorGender,
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
    documentImgUrl = json['documentImgUrl'];
    licenseImgUrl = json['licenseImgUrl'];
    currentAddress = json['currentAddress'];
    pinCode = json['pin_code'];
    carnumber = json['carnumber'];
    subscriptionPlan = json['subscriptionPlan'];
    subscriptionDate = json['subscription_date'];
    subEndDate = json['sub_end_date'];
    vendorGender = json['vendor_gender'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['phone'] = phone;
    data['aadhaar_number'] = aadhaarNumber;
    data['email'] = email;
    data['password'] = password;
    data['status'] = status;
    data['isVerified'] = isVerified;
    data['businessName'] = businessName;
    data['city'] = city;
    data['vendor_cat'] = vendorCat;
    data['profileImgUrl'] = profileImgUrl;
    data['documentImgUrl'] = documentImgUrl;
    data['licenseImgUrl'] = licenseImgUrl;
    data['currentAddress'] = currentAddress;
    data['pin_code'] = pinCode;
    data['carnumber'] = carnumber;
    data['subscriptionPlan'] = subscriptionPlan;
    data['subscription_date'] = subscriptionDate;
    data['sub_end_date'] = subEndDate;
    data['vendor_gender'] = vendorGender;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
