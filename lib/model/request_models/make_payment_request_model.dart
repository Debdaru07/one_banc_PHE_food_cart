class MakePaymentRequestModel {
  String? totalAmount;
  int? totalItems;
  List<Data>? data;

  MakePaymentRequestModel({this.totalAmount, this.totalItems, this.data});

  MakePaymentRequestModel.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    totalItems = json['total_items'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_amount'] = this.totalAmount;
    data['total_items'] = this.totalItems;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? cuisineId;
  int? itemId;
  int? itemPrice;
  int? itemQuantity;

  Data({
    this.cuisineId,
    this.itemId,
    this.itemPrice,
    this.itemQuantity,
  });

  Data.fromJson(Map<String, dynamic> json) {
    cuisineId = json['cuisine_id'];
    itemId = json['item_id'];
    itemPrice = json['item_price'];
    itemQuantity = json['item_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cuisine_id'] = this.cuisineId;
    data['item_id'] = this.itemId;
    data['item_price'] = this.itemPrice;
    data['item_quantity'] = this.itemQuantity;
    return data;
  }
}