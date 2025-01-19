class ItemsListModel {
  int? responseCode;
  int? outcomeCode;
  String? responseMessage;
  int? page;
  int? count;
  int? totalPages;
  int? totalItems;
  List<Cuisines>? cuisines;
  String? timestamp;
  String? requesterIp;
  String? timetaken;

  ItemsListModel(
      {this.responseCode,
      this.outcomeCode,
      this.responseMessage,
      this.page,
      this.count,
      this.totalPages,
      this.totalItems,
      this.cuisines,
      this.timestamp,
      this.requesterIp,
      this.timetaken});

  ItemsListModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    outcomeCode = json['outcome_code'];
    responseMessage = json['response_message'];
    page = json['page'];
    count = json['count'];
    totalPages = json['total_pages'];
    totalItems = json['total_items'];
    if (json['cuisines'] != null) {
      cuisines = [];
      json['cuisines'].forEach((v) {
        cuisines?.add(new Cuisines.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
    requesterIp = json['requester_ip'];
    timetaken = json['timetaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['outcome_code'] = this.outcomeCode;
    data['response_message'] = this.responseMessage;
    data['page'] = this.page;
    data['count'] = this.count;
    data['total_pages'] = this.totalPages;
    data['total_items'] = this.totalItems;
    if (this.cuisines != null) {
      data['cuisines'] = this.cuisines?.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    data['requester_ip'] = this.requesterIp;
    data['timetaken'] = this.timetaken;
    return data;
  }
}

class Cuisines {
  String? cuisineId;
  String? cuisineName;
  String? cuisineImageUrl;
  List<Items>? items;

  Cuisines({this.cuisineId, this.cuisineName, this.cuisineImageUrl, this.items});

  Cuisines.fromJson(Map<String, dynamic> json) {
    cuisineId = json['cuisine_id'];
    cuisineName = json['cuisine_name'];
    cuisineImageUrl = json['cuisine_image_url'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cuisine_id'] = this.cuisineId;
    data['cuisine_name'] = this.cuisineName;
    data['cuisine_image_url'] = this.cuisineImageUrl;
    if (this.items != null) {
      data['items'] = this.items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? name;
  String? imageUrl;
  String? price;
  String? rating;

  Items({this.id, this.name, this.imageUrl, this.price, this.rating});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    price = json['price'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['price'] = this.price;
    data['rating'] = this.rating;
    return data;
  }
}
