import 'package:flutter_test/flutter_test.dart';
import 'package:munch/model/food_model.dart';
import 'package:munch/view_model/search_food_view_model.dart';

void main() {
  late FoodViewModel foodViewModel;

  setUp(() {
    foodViewModel = FoodViewModel();
  });

  group('FoodViewModel Tests', () {
    test('Initial state should have loading as false', () {
      expect(foodViewModel.loading, false);
    });

    test('setLoading should update loading state', () {
      foodViewModel.setLoading(true);
      expect(foodViewModel.loading, true);
    });

    test('setFoodItems should update filteredFoodList', () {
      final foodItems = [
        Food(name: "Test Food", category: "Test", businessName: "Test Business", foodType: "Veg", ratings: "5.0", thumNailAssetPath: "assets/images/test.jpg", price: '100'),
      ];
      foodViewModel.setFoodItems(foodItems);
      expect(foodViewModel.filteredFoodList, foodItems);
    });

    test('searchFood should filter food items based on query', () async {
      foodViewModel.searchFood('burger');
      await Future.delayed(const Duration(seconds: 2)); 
      expect(foodViewModel.filteredFoodList.length, 3);
    });

    test('toggleViewType should toggle between list and grid view types', () {
      expect(foodViewModel.viewType, ViewType.grid);
      foodViewModel.toggleViewType();
      expect(foodViewModel.viewType, ViewType.list);
      foodViewModel.toggleViewType();
      expect(foodViewModel.viewType, ViewType.grid);
    });

    test('setCartItems should add food item to cart', () {
      final foodItem = Food(name: "Classic Cheeseburger", category: "Burger", businessName: "Burger Palace", foodType: "Non-Veg", ratings: "4.5", thumNailAssetPath: "assets/images/burger1.jpg", price: '150',);
      foodViewModel.setCartItems(foodItem);
      expect(foodViewModel.cartItems.length, 1);
      expect(foodViewModel.cartItems[0], foodItem);
    });

    test('resetCartItems should clear the cart', () {
      final foodItem = Food(name: "Classic Cheeseburger", category: "Burger", businessName: "Burger Palace", foodType: "Non-Veg", ratings: "4.5", thumNailAssetPath: "assets/images/burger1.jpg", price: '150',);
      foodViewModel.setCartItems(foodItem);
      expect(foodViewModel.cartItems.length, 1);
      foodViewModel.resetCartItems();
      expect(foodViewModel.cartItems.length, 0);
    });
  });
}
