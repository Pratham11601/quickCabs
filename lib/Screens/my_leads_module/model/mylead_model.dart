class MyLeadModel {
  bool? status;
  String? message;
  int? totalItems;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  bool? isNext;
  bool? isPrev;
  List<Lead>? leads;

  MyLeadModel(
      {this.status, this.message, this.totalItems, this.totalPages, this.currentPage, this.pageSize, this.isNext, this.isPrev, this.leads});

  MyLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    isNext = json['isNext'];
    isPrev = json['isPrev'];
    if (json['leads'] != null) {
      leads = <Lead>[];
      json['leads'].forEach((v) {
        leads!.add(new Lead.fromJson(v));
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
    if (leads != null) {
      data['leads'] = leads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lead {
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

  Lead(
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
      this.updatedAt});

  Lead.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    return data;
  }
}
