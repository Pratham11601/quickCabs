class SubscriptionStatusModel {
  int? status;
  String? message;
  bool? isSubscribtionActive;
  Subscription? subscription;

  SubscriptionStatusModel({this.status, this.message, this.isSubscribtionActive, this.subscription});

  SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isSubscribtionActive = json['isSubscribtionActive'];
    subscription = json['subscription'] != null ? new Subscription.fromJson(json['subscription']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['isSubscribtionActive'] = this.isSubscribtionActive;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  String? plan;
  String? lastRechargedDate;
  String? endDate;
  bool? isActive;

  Subscription({this.plan, this.lastRechargedDate, this.endDate, this.isActive});

  Subscription.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    lastRechargedDate = json['LastRechargedDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = this.plan;
    data['LastRechargedDate'] = this.lastRechargedDate;
    data['endDate'] = this.endDate;
    data['isActive'] = this.isActive;
    return data;
  }
}
