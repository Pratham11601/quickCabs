class NewsModel {
  bool? success;
  NewsData? data;

  NewsModel({this.success, this.data});

  NewsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? NewsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NewsData {
  int? id;
  String? announcement;

  NewsData({this.id, this.announcement});

  NewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    announcement = json['announcement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['announcement'] = announcement;
    return data;
  }
}
