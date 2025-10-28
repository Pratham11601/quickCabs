class ActiveLeadModel {
  bool? status;
  String? message;
  int? totalItems;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  bool? isNext;
  bool? isPrev;
  List<Post>? posts;

  ActiveLeadModel(
      {this.status, this.message, this.totalItems, this.totalPages, this.currentPage, this.pageSize, this.isNext, this.isPrev, this.posts});

  ActiveLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    isNext = json['isNext'];
    isPrev = json['isPrev'];
    if (json['posts'] != null) {
      posts = <Post>[];
      json['posts'].forEach((v) {
        posts!.add(Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['totalItems'] = totalItems;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    data['isNext'] = isNext;
    data['isPrev'] = isPrev;
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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
  String? time;
  int? isActive;
  String? vendorContact;
  String? vendorCat;
  String? createdAt;
  String? updatedAt;
  int? tripType;
  int? acceptedById;
  String? otp;
  String? leadStatus;
  String? rentalDuration;
  String? startDate;
  String? endDate;
  String? tollTax;
  String? carrier;
  String? fuelType;
  String? vendorFullname;
  String? vendorEmail;
  String? vendorCity;
  String? profileImgUrl;
  String? acceptedByFullname;
  String? acceptedByEmail;
  String? acceptedByPhone;

  Post(
      {this.id,
      this.date,
      this.vendorId,
      this.vendorName,
      this.locationFrom,
      this.locationFromArea,
      this.carModel,
      this.addOn,
      this.fare,
      this.toLocation,
      this.toLocationArea,
      this.time,
      this.isActive,
      this.vendorContact,
      this.vendorCat,
      this.createdAt,
      this.updatedAt,
      this.tripType,
      this.acceptedById,
      this.otp,
      this.leadStatus,
      this.rentalDuration,
      this.startDate,
      this.endDate,
      this.tollTax,
      this.carrier,
      this.fuelType,
      this.vendorFullname,
      this.vendorEmail,
      this.vendorCity,
      this.profileImgUrl,
      this.acceptedByFullname,
      this.acceptedByEmail,
      this.acceptedByPhone});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    locationFrom = json['location_from'];
    locationFromArea = json['location_from_area'];
    carModel = json['car_model'];
    addOn = json['add_on'];
    fare = json['fare'];
    toLocation = json['to_location'];
    toLocationArea = json['to_location_area'];
    time = json['time'];
    isActive = json['is_active'];
    vendorContact = json['vendor_contact'];
    vendorCat = json['vendor_cat'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    tripType = json['trip_type'];
    acceptedById = json['acceptedById'];
    otp = json['otp'];
    leadStatus = json['lead_status'];
    rentalDuration = json['rental_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    tollTax = json['toll_tax'];
    carrier = json['carrier'];
    fuelType = json['fuel_type'];
    vendorFullname = json['vendor_fullname'];
    vendorEmail = json['vendor_email'];
    vendorCity = json['vendor_city'];
    profileImgUrl = json['profileImgUrl'];
    acceptedByFullname = json['acceptedBy_fullname'];
    acceptedByEmail = json['acceptedBy_email'];
    acceptedByPhone = json['acceptedBy_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['vendor_id'] = vendorId;
    data['vendor_name'] = vendorName;
    data['location_from'] = locationFrom;
    data['location_from_area'] = locationFromArea;
    data['car_model'] = carModel;
    data['add_on'] = addOn;
    data['fare'] = fare;
    data['to_location'] = toLocation;
    data['to_location_area'] = toLocationArea;
    data['time'] = time;
    data['is_active'] = isActive;
    data['vendor_contact'] = vendorContact;
    data['vendor_cat'] = vendorCat;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['trip_type'] = tripType;
    data['acceptedById'] = acceptedById;
    data['otp'] = otp;
    data['lead_status'] = leadStatus;
    data['rental_duration'] = rentalDuration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['toll_tax'] = tollTax;
    data['carrier'] = carrier;
    data['fuel_type'] = fuelType;
    data['vendor_fullname'] = vendorFullname;
    data['vendor_email'] = vendorEmail;
    data['vendor_city'] = vendorCity;
    data['profileImgUrl'] = profileImgUrl;
    data['acceptedBy_fullname'] = acceptedByFullname;
    data['acceptedBy_email'] = acceptedByEmail;
    data['acceptedBy_phone'] = acceptedByPhone;
    return data;
  }
}
