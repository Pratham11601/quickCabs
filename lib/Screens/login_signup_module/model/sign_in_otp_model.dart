class SignInOtpModel {
  bool? status;
  String? message;
  int? otp;

  SignInOtpModel({this.status, this.message, this.otp});

  SignInOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['otp'] = otp;
    return data;
  }
}
