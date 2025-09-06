class PackagesModel {
  int? status;
  List<Packages>? packages;

  PackagesModel({this.status, this.packages});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int? id;
  String? packageName;
  int? durationInDays;
  int? pricePerDay;
  int? totalPrice;
  String? createdAt;
  String? updatedAt;

  Packages(
      {this.id,
        this.packageName,
        this.durationInDays,
        this.pricePerDay,
        this.totalPrice,
        this.createdAt,
        this.updatedAt});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['package_name'];
    durationInDays = json['duration_in_days'];
    pricePerDay = json['price_per_day'];
    totalPrice = json['total_price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_name'] = packageName;
    data['duration_in_days'] = durationInDays;
    data['price_per_day'] = pricePerDay;
    data['total_price'] = totalPrice;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
