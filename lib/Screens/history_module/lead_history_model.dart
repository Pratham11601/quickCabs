class LeadHistoryModel {
  int? totalItems;
  int? totalPages;
  int? currentPage;
  List<Leads>? leads;
  String? message;

  LeadHistoryModel({this.totalItems, this.totalPages, this.currentPage, this.leads, this.message});

  LeadHistoryModel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    if (json['leads'] != null) {
      leads = <Leads>[];
      json['leads'].forEach((v) {
        leads!.add(Leads.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalItems'] = totalItems;
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    if (leads != null) {
      data['leads'] = leads!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Leads {
  int? id;
  String? date;
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
  int? tripType;
  String? otp;
  int? acceptedById;
  String? leadStatus;
  String? rentalDuration;
  String? tollTax;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  Creator? creator;
  AcceptedBy? acceptedBy;

  Leads(
      {this.id,
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
      this.tripType,
      this.otp,
      this.acceptedById,
      this.leadStatus,
      this.rentalDuration,
      this.tollTax,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.creator,
      this.acceptedBy});

  Leads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    locationFrom = json['location_from'];
    locationFromArea = json['location_from_area'];
    toLocation = json['to_location'];
    toLocationArea = json['to_location_area'];
    carModel = json['car_model'];
    addOn = json['add_on'];
    fare = json['fare'];
    time = json['time'];
    isActive = json['is_active'];
    vendorContact = json['vendor_contact'];
    vendorCat = json['vendor_cat'];
    tripType = json['trip_type'];
    otp = json['otp'];
    acceptedById = json['acceptedById'];
    leadStatus = json['lead_status'];
    rentalDuration = json['rental_duration'];
    tollTax = json['toll_tax'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    creator = json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    acceptedBy = json['acceptedBy'] != null ? new AcceptedBy.fromJson(json['acceptedBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['date'] = date;
    data['vendor_id'] = vendorId;
    data['vendor_name'] = vendorName;
    data['location_from'] = locationFrom;
    data['location_from_area'] = locationFromArea;
    data['to_location'] = toLocation;
    data['to_location_area'] = toLocationArea;
    data['car_model'] = carModel;
    data['add_on'] = addOn;
    data['fare'] = fare;
    data['time'] = time;
    data['is_active'] = isActive;
    data['vendor_contact'] = vendorContact;
    data['vendor_cat'] = vendorCat;
    data['trip_type'] = tripType;
    data['otp'] = otp;
    data['acceptedById'] = acceptedById;
    data['lead_status'] = leadStatus;
    data['rental_duration'] = rentalDuration;
    data['toll_tax'] = tollTax;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    if (acceptedBy != null) {
      data['acceptedBy'] = acceptedBy!.toJson();
    }
    return data;
  }
}

class Creator {
  String? fullname;
  String? email;
  String? city;
  String? profileImgUrl;

  Creator({this.fullname, this.email, this.city, this.profileImgUrl});

  Creator.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    email = json['email'];
    city = json['city'];
    profileImgUrl = json['profileImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = fullname;
    data['email'] = email;
    data['city'] = city;
    data['profileImgUrl'] = profileImgUrl;
    return data;
  }
}

class AcceptedBy {
  int? id;
  String? fullname;
  String? phone;

  AcceptedBy({this.id, this.fullname, this.phone});

  AcceptedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fullname'] = fullname;
    data['phone'] = phone;
    return data;
  }
}
