class VendorResponse {
  bool? status;
  String? message;
  int? total;
  int? totalPages;
  int? currentPage;
  bool? isNext;
  List<Vendors>? vendors;

  VendorResponse({this.status, this.message, this.total, this.totalPages, this.currentPage, this.isNext, this.vendors});

  VendorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    isNext = json['isNext'];
    if (json['vendors'] != null) {
      vendors = <Vendors>[];
      json['vendors'].forEach((v) {
        vendors!.add(new Vendors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    data['isNext'] = this.isNext;
    if (this.vendors != null) {
      data['vendors'] = this.vendors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendors {
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
  String? vehicleImgUrl;
  String? shopImgUrl;
  String? documentImgUrl;
  String? licenseImgUrl;
  String? currentAddress;
  String? pinCode;
  String? carnumber;
  String? subscriptionPlan;
  String? subscriptionDate;
  String? subEndDate;
  String? vendorGender;
  String? fcmToken;
  String? referredBy;
  String? createdAt;
  String? updatedAt;

  Vendors(
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

  Vendors.fromJson(Map<String, dynamic> json) {
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
