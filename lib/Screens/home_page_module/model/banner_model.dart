class BannerModel {
  bool? status;
  String? message;
  List<FormattedAdvertisements>? formattedAdvertisements;

  BannerModel({this.status, this.message, this.formattedAdvertisements});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['formattedAdvertisements'] != null) {
      formattedAdvertisements = <FormattedAdvertisements>[];
      json['formattedAdvertisements'].forEach((v) {
        formattedAdvertisements!.add(new FormattedAdvertisements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (formattedAdvertisements != null) {
      data['formattedAdvertisements'] =
          formattedAdvertisements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FormattedAdvertisements {
  int? id;
  String? image;
  String? postedFrom;
  String? date;

  FormattedAdvertisements({this.id, this.image, this.postedFrom, this.date});

  FormattedAdvertisements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    postedFrom = json['postedFrom'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['postedFrom'] = postedFrom;
    data['date'] = date;
    return data;
  }
}
