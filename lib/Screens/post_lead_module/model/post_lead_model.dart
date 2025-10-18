class PostLeadModel {
  bool? status;
  String? message;
  Lead? lead;

  PostLeadModel({this.status, this.message, this.lead});

  PostLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    lead = json['lead'] != null ? Lead.fromJson(json['lead']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (lead != null) {
      data['lead'] = lead!.toJson();
    }
    return data;
  }
}

class Lead {
  String? leadStatus;
  int? id;
  String? vendorName;
  int? vendorId;
  String? vendorCat;
  String? vendorContact;
  String? date;
  int? tripType;
  String? time;
  String? locationFrom;
  String? locationFromArea;
  String? toLocation;
  String? toLocationArea;
  String? carModel;
  String? addOn;
  int? fare;
  int? otp;
  bool? isActive;
  String? rentalDuration;
  String? tollTax;
  String? startDate;
  String? endDate;
  String? updatedAt;
  String? createdAt;

  Lead(
      {this.leadStatus,
      this.id,
      this.vendorName,
      this.vendorId,
      this.vendorCat,
      this.vendorContact,
      this.date,
      this.tripType,
      this.time,
      this.locationFrom,
      this.locationFromArea,
      this.toLocation,
      this.toLocationArea,
      this.carModel,
      this.addOn,
      this.fare,
      this.otp,
      this.isActive,
      this.rentalDuration,
      this.tollTax,
      this.startDate,
      this.endDate,
      this.updatedAt,
      this.createdAt});

  Lead.fromJson(Map<String, dynamic> json) {
    leadStatus = json['lead_status'];
    id = json['id'];
    vendorName = json['vendor_name'];
    vendorId = json['vendor_id'];
    vendorCat = json['vendor_cat'];
    vendorContact = json['vendor_contact'];
    date = json['date'];
    tripType = json['trip_type'];
    time = json['time'];
    locationFrom = json['location_from'];
    locationFromArea = json['location_from_area'];
    toLocation = json['to_location'];
    toLocationArea = json['to_location_area'];
    carModel = json['car_model'];
    addOn = json['add_on'];
    fare = json['fare'];
    otp = json['otp'];
    isActive = json['is_active'];
    rentalDuration = json['rental_duration'];
    tollTax = json['toll_tax'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_status'] = leadStatus;
    data['id'] = id;
    data['vendor_name'] = vendorName;
    data['vendor_id'] = vendorId;
    data['vendor_cat'] = vendorCat;
    data['vendor_contact'] = vendorContact;
    data['date'] = date;
    data['trip_type'] = tripType;
    data['time'] = time;
    data['location_from'] = locationFrom;
    data['location_from_area'] = locationFromArea;
    data['to_location'] = toLocation;
    data['to_location_area'] = toLocationArea;
    data['car_model'] = carModel;
    data['add_on'] = addOn;
    data['fare'] = fare;
    data['otp'] = otp;
    data['is_active'] = isActive;
    data['rental_duration'] = rentalDuration;
    data['toll_tax'] = tollTax;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
