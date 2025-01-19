class ItemDetailsResponseModel {
  int? responseCode;
  int? outcomeCode;
  String? responseMessage;
  String? cuisineId;
  String? cuisineName;
  String? cuisineImageUrl;
  int? itemId;
  String? itemName;
  int? itemPrice;
  double? itemRating;
  String? itemImageUrl;
  String? timestamp;
  String? requesterIp;
  String? timetaken;

  ItemDetailsResponseModel(
      {this.responseCode,
      this.outcomeCode,
      this.responseMessage,
      this.cuisineId,
      this.cuisineName,
      this.cuisineImageUrl,
      this.itemId,
      this.itemName,
      this.itemPrice,
      this.itemRating,
      this.itemImageUrl,
      this.timestamp,
      this.requesterIp,
      this.timetaken});

  ItemDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    outcomeCode = json['outcome_code'];
    responseMessage = json['response_message'];
    cuisineId = json['cuisine_id'];
    cuisineName = json['cuisine_name'];
    cuisineImageUrl = json['cuisine_image_url'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemRating = json['item_rating'];
    itemImageUrl = json['item_image_url'];
    timestamp = json['timestamp'];
    requesterIp = json['requester_ip'];
    timetaken = json['timetaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['outcome_code'] = this.outcomeCode;
    data['response_message'] = this.responseMessage;
    data['cuisine_id'] = this.cuisineId;
    data['cuisine_name'] = this.cuisineName;
    data['cuisine_image_url'] = this.cuisineImageUrl;
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    data['item_price'] = this.itemPrice;
    data['item_rating'] = this.itemRating;
    data['item_image_url'] = this.itemImageUrl;
    data['timestamp'] = this.timestamp;
    data['requester_ip'] = this.requesterIp;
    data['timetaken'] = this.timetaken;
    return data;
  }
}