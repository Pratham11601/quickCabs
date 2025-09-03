class LeadByListModel {
  int? status;
  String? message;
  List<LeadByListData>? data;
  
  LeadByListModel({this.status, this.message, this.data});

  LeadByListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeadByListData>[];
      json['data'].forEach((v) {
        data!.add(new LeadByListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadByListData {
  int? id;
  String? name;
  String? phone;
  String? createdAt;
  String? updatedAt;

  LeadByListData({this.id, this.name, this.phone, this.createdAt, this.updatedAt});

  LeadByListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
