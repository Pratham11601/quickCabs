class CreateOrderModel {
  int? status;
  String? message;
  Order? order;

  CreateOrderModel({this.status, this.message, this.order});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? id;
  int? amount;
  String? currency;
  String? status;

  Order({this.id, this.amount, this.currency, this.status});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['currency'] = currency;
    data['status'] = status;
    return data;
  }
}
