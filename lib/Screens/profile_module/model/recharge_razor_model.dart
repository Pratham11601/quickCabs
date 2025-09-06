class RechargeRazorModel {
  int? status;
  String? message;
  bool? isSubscribtionActive;
  Subscription? subscription;

  RechargeRazorModel(
      {this.status,
        this.message,
        this.isSubscribtionActive,
        this.subscription});

  RechargeRazorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isSubscribtionActive = json['isSubscribtionActive'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['isSubscribtionActive'] = isSubscribtionActive;
    if (this.subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  Null? plan;
  Null? lastRechargedDate;
  Null? endDate;
  bool? isActive;

  Subscription(
      {this.plan, this.lastRechargedDate, this.endDate, this.isActive});

  Subscription.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    lastRechargedDate = json['LastRechargedDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plan'] = plan;
    data['LastRechargedDate'] = lastRechargedDate;
    data['endDate'] = endDate;
    data['isActive'] = isActive;
    return data;
  }
}
