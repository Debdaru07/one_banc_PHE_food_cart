class ItemsFilterRequestModel {
  List<String>? cuisineType;
  PriceRange? priceRange;
  double? minRating;

  ItemsFilterRequestModel({this.cuisineType, this.priceRange, this.minRating});

  ItemsFilterRequestModel.fromJson(Map<String, dynamic> json) {
    cuisineType = json['cuisine_type'].cast<String>();
    priceRange = json['price_range'] != null
        ? new PriceRange.fromJson(json['price_range'])
        : null;
    minRating = json['min_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cuisine_type'] = this.cuisineType;
    if (this.priceRange != null) {
      data['price_range'] = this.priceRange?.toJson();
    }
    data['min_rating'] = this.minRating;
    return data;
  }

  bool get isFilterSelected {
    bool isCuisineTypeEmpty = this.cuisineType == null || this.cuisineType!.isEmpty;
    bool isPriceRangeEmpty = this.priceRange == null ||  (this.priceRange!.minAmount == null || this.priceRange!.minAmount == 0) && (this.priceRange!.maxAmount == null || this.priceRange!.maxAmount == 0);
    bool isMinRatingEmpty = this.minRating == null || this.minRating == 0.0;

    return isCuisineTypeEmpty && isPriceRangeEmpty && isMinRatingEmpty;
  }
}

class PriceRange {
  int? minAmount;
  int? maxAmount;

  PriceRange({this.minAmount, this.maxAmount});

  PriceRange.fromJson(Map<String, dynamic> json) {
    minAmount = json['min_amount'];
    maxAmount = json['max_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_amount'] = this.minAmount;
    data['max_amount'] = this.maxAmount;
    return data;
  }
}