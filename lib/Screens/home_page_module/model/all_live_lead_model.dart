class AllLiveLeadModel {
  int? status;
  List<AllLiveLeadData>? data;
  Pagination? pagination;

  AllLiveLeadModel({this.status, this.data, this.pagination});

  AllLiveLeadModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AllLiveLeadData>[];
      json['data'].forEach((v) {
        data!.add(new AllLiveLeadData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AllLiveLeadData {
  int? id;
  int? userId;
  String? car;
  String? location;
  String? fromDate;
  String? fromTime;
  String? toDate;
  String? toTime;
  String? phone;
  int? status;
  String? name;
  String? createdAt;
  String? updatedAt;

  AllLiveLeadData(
      {this.id,
      this.userId,
      this.car,
      this.location,
      this.fromDate,
      this.fromTime,
      this.toDate,
      this.toTime,
      this.phone,
      this.status,
      this.name,
      this.createdAt,
      this.updatedAt});

  AllLiveLeadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    car = json['car'];
    location = json['location'];
    fromDate = json['from_date'];
    fromTime = json['from_time'];
    toDate = json['to_date'];
    toTime = json['to_time'];
    phone = json['phone'];
    status = json['status'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['car'] = this.car;
    data['location'] = this.location;
    data['from_date'] = this.fromDate;
    data['from_time'] = this.fromTime;
    data['to_date'] = this.toDate;
    data['to_time'] = this.toTime;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int? totalCount;
  int? page;
  int? limit;
  int? totalPages;
  bool? hasNext;
  bool? hasPrevious;

  Pagination({this.totalCount, this.page, this.limit, this.totalPages, this.hasNext, this.hasPrevious});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    hasNext = json['hasNext'];
    hasPrevious = json['hasPrevious'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    data['hasNext'] = this.hasNext;
    data['hasPrevious'] = this.hasPrevious;
    return data;
  }
}
