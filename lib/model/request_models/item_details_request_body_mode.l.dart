class ItemListDetailsRequestBodyModel {
  int? itemId;

  ItemListDetailsRequestBodyModel({this.itemId});

  ItemListDetailsRequestBodyModel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    return data;
  }
}
