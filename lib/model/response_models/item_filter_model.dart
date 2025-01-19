class ItemsFilterModel {
  int? responseCode;
  int? outcomeCode;
  String? responseMessage;
  List<Cuisines>? cuisines;
  String? timestamp;
  String? requesterIp;
  String? timetaken;

  ItemsFilterModel(
      {this.responseCode,
      this.outcomeCode,
      this.responseMessage,
      this.cuisines,
      this.timestamp,
      this.requesterIp,
      this.timetaken});

  ItemsFilterModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    outcomeCode = json['outcome_code'];
    responseMessage = json['response_message'];
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
  int? cuisineId;
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
  int? id;
  String? name;
  String? imageUrl;

  Items({this.id, this.name, this.imageUrl});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
