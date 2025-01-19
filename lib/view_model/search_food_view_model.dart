import 'package:flutter/material.dart';
import '../model/food_model.dart';

enum ViewType { list, grid }

class FoodViewModel extends ChangeNotifier {

  List<Food> foodItems = [
    // Burgers
    Food(name: "Classic Cheeseburger", category: "Burger", businessName: "Burger Palace", foodType: "Non-Veg", ratings: "4.5", thumNailAssetPath: "assets/images/burger1.jpg", price: '3',),
    Food(name: "Veggie Burger", category: "Burger", businessName: "Green Bites", foodType: "Veg", ratings: "4.2", thumNailAssetPath: "assets/images/burger1.jpg", price: '2',),
    Food(name: "Spicy Bean Burger", category: "Burger", businessName: "Spicy Bites", foodType: "Veg", ratings: "4.1", thumNailAssetPath: "assets/images/burger1.jpg", price: '5',),

    // Juices
    Food(name: "Fresh Orange Juice", category: "Juice", businessName: "Juice Bar", foodType: "Veg", ratings: "4.8", thumNailAssetPath: "assets/images/juice.jpg", price: '5',),
    Food(name: "Mixed Berry Smoothie", category: "Juice", businessName: "Smoothie Spot", foodType: "Veg", ratings: "4.6", thumNailAssetPath: "assets/images/juice.jpg", price: '3',),
    Food(name: "Green Detox Juice", category: "Juice", businessName: "Health Haven", foodType: "Veg", ratings: "4.9", thumNailAssetPath: "assets/images/juice.jpg", price: '2',),

    // Pizzas
    Food(name: "Pepperoni Pizza", category: "Pizza", businessName: "Pizzeria Italia", foodType: "Non-Veg", ratings: "4.7", thumNailAssetPath: "assets/images/pizza.jpg", price: '1',),
    Food(name: "Margherita Pizza", category: "Pizza", businessName: "Pizza Corner", foodType: "Veg", ratings: "4.4", thumNailAssetPath: "assets/images/pizza.jpg", price: '3',),
    Food(name: "BBQ Chicken Pizza", category: "Pizza", businessName: "Pizza Express", foodType: "Non-Veg", ratings: "4.6", thumNailAssetPath: "assets/images/pizza.jpg", price: '5',),

    // Sandwiches
    Food(name: "Grilled Chicken Sandwich", category: "Sandwich", businessName: "Sandwich Hub", foodType: "Non-Veg", ratings: "4.3", thumNailAssetPath: "assets/images/sandwich.jpg", price: '1',),
    Food(name: "Caprese Sandwich", category: "Sandwich", businessName: "Deli Fresh", foodType: "Veg", ratings: "4.5", thumNailAssetPath: "assets/images/sandwich.jpg", price: '2',),
    Food(name: "Turkey Club Sandwich", category: "Sandwich", businessName: "Club Sandwich Co.", foodType: "Non-Veg", ratings: "4.3", thumNailAssetPath: "assets/images/sandwich.jpg", price: '8',),
  ];

  List<Food> _filteredFoodList = [];
  List<Food> get filteredFoodList => _filteredFoodList;

  setFoodItems(List<Food> value) {
    _filteredFoodList = value;
  }

  bool _loading = false; 
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  void searchFood(String query) async {
    List<Food> searchItems = [];
    Future.delayed(Duration.zero, () async {
      setLoading(true);
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      searchItems = foodItems.where((food) {
        return food.name.toLowerCase().contains(query.toLowerCase()) ||
            food.category.toLowerCase().contains(query.toLowerCase()) ||
            food.businessName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setFoodItems(searchItems);
      setLoading(false);
      notifyListeners();
    });
  }
  
  ViewType _viewType = ViewType.grid;
  ViewType get viewType => _viewType;

  void toggleViewType() {
    _viewType = _viewType == ViewType.grid ? ViewType.list : ViewType.grid;
    notifyListeners();
  }

  List<Food> _cartItems = [];
  List<Food> get cartItems => _cartItems;
  
  setCartItems(Food value) {
    _cartItems.add(value);
    notifyListeners();
  }

  resetCartItems() {
    _cartItems.clear();
    notifyListeners();
  }

}