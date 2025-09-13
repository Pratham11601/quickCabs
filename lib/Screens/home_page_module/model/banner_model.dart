class BannerModel {
  int? id;
  String? image;
  String? postedFrom;
  String? date;

  BannerModel({this.id, this.image, this.postedFrom, this.date});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    postedFrom = json['postedFrom'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['postedFrom'] = this.postedFrom;
    data['date'] = this.date;
    return data;
  }
}
