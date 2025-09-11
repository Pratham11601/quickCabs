class EditLeadModel {
  bool? status;
  String? message;
  EditLead? lead;

  EditLeadModel({this.status, this.message, this.lead});

  EditLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    lead = json['lead'] != null ? new EditLead.fromJson(json['lead']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.lead != null) {
      data['lead'] = this.lead!.toJson();
    }
    return data;
  }
}

class EditLead {
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
  dynamic fare;
  String? time;
  bool? isActive;
  String? vendorContact;
  String? vendorCat;
  int? tripType;
  String? otp;
  String? acceptedById;
  String? createdAt;
  String? updatedAt;

  EditLead(
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
      this.createdAt,
      this.updatedAt});

  EditLead.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['location_from'] = this.locationFrom;
    data['location_from_area'] = this.locationFromArea;
    data['to_location'] = this.toLocation;
    data['to_location_area'] = this.toLocationArea;
    data['car_model'] = this.carModel;
    data['add_on'] = this.addOn;
    data['fare'] = this.fare;
    data['time'] = this.time;
    data['is_active'] = this.isActive;
    data['vendor_contact'] = this.vendorContact;
    data['vendor_cat'] = this.vendorCat;
    data['trip_type'] = this.tripType;
    data['otp'] = this.otp;
    data['acceptedById'] = this.acceptedById;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
