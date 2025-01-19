class Food {
  String name;              // Name of the food item
  String category;          // Category of the food (e.g., pizza, burger)
  String businessName;      // Name of the business offering the food
  String foodType;          // Type of food: "veg" or "non-veg"
  String ratings;           // Rating of the food item
  String thumNailAssetPath;
  String price;

  Food({
    required this.name,
    required this.category,
    required this.businessName,
    required this.foodType,
    required this.ratings,
    required this.thumNailAssetPath, 
    required this.price
  });

  Food.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        category = json['category'],
        businessName = json['businessName'],
        foodType = json['foodType'],
        ratings = json['ratings'],
        thumNailAssetPath = json['thumNailAssetPath'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'businessName': businessName,
      'foodType': foodType,
      'ratings': ratings,
      'thumNailAssetPath': thumNailAssetPath,
      'price': price
    };
  }
}
