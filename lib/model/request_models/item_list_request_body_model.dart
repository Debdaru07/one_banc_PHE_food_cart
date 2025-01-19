class ItemListRequestModel {
  int? page;
  int? count;

  ItemListRequestModel({this.page, this.count});

  ItemListRequestModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['count'] = this.count;
    return data;
  }
}
