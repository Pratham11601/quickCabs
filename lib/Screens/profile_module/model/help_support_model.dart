class HelpSupportModel {
  int? status;
  List<HelpSupportData>? data;

  HelpSupportModel({this.status, this.data});

  HelpSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <HelpSupportData>[];
      json['data'].forEach((v) {
        data!.add(new HelpSupportData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HelpSupportData {
  int? id;
  String? state;
  String? createdAt;
  String? updatedAt;
  List<PhoneNumbers>? phoneNumbers;

  HelpSupportData({this.id, this.state, this.createdAt, this.updatedAt, this.phoneNumbers});

  HelpSupportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['phoneNumbers'] != null) {
      phoneNumbers = <PhoneNumbers>[];
      json['phoneNumbers'].forEach((v) {
        phoneNumbers!.add(new PhoneNumbers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.phoneNumbers != null) {
      data['phoneNumbers'] = this.phoneNumbers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhoneNumbers {
  int? id;
  String? phoneNumber;
  int? helpsupportdetailId;
  String? createdAt;
  String? updatedAt;

  PhoneNumbers({this.id, this.phoneNumber, this.helpsupportdetailId, this.createdAt, this.updatedAt});

  PhoneNumbers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    helpsupportdetailId = json['helpsupportdetailId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['helpsupportdetailId'] = this.helpsupportdetailId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
