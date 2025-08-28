class LoginModel {
  bool? status;
  String? message;
  int? userId;
  String? userName;
  String? token;

  LoginModel(
      {this.status, this.message, this.userId, this.userName, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
    userName = json['userName'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['userId'] = userId;
    data['userName'] = userName;
    data['token'] = token;
    return data;
  }
}
