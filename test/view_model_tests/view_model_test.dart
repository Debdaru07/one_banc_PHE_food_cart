import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:munch/model/request_models/item_list_request_body_model.dart';
import 'package:munch/model/request_models/make_payment_request_model.dart';
import 'package:munch/model/response_models/item_details_model.dart';
import 'package:munch/model/response_models/item_list_model.dart';
import 'package:munch/service/common_post_api_handler.dart';
import 'package:munch/view_model/item_fetch_vm.dart';

import 'api_service_test.mocks.dart';


void main() {
  late FoodItemsVM viewModel;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    viewModel = FoodItemsVM(apiService: mockApiService);
  });

  group('FoodItemsVM Tests', () {
    test('Initial state is completed', () {
      expect(viewModel.state, RequestState.completed);
      expect(viewModel.errorMessage, '');
      expect(viewModel.itemsListModel, isNull);
    });

    test('fetchItemList updates state and itemsListModel on success', () async {
      // Mock data
      final mockRequest = ItemListRequestModel();
      final mockResponse = ItemsListModel(responseCode: 200);
      when(mockApiService.postRequest<ItemListRequestModel, ItemsListModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockResponse);


      await viewModel.fetchItemList(mockRequest);

      expect(viewModel.state, RequestState.completed);
      expect(viewModel.itemsListModel, isNotNull);
      expect(viewModel.itemsListModel?.responseCode, 200);
    });

    test('fetchItemList handles errors', () async {
      final mockRequest = ItemListRequestModel();
      final mockErrorMessage = 'Network error occurred';

      when(mockApiService.postRequest<ItemListRequestModel, ItemsListModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenThrow(Exception(mockErrorMessage));

      await viewModel.fetchItemList(mockRequest);

      expect(viewModel.state, RequestState.error);
      expect(viewModel.errorMessage, contains('Network error occurred'));
    });

    test('Cart operations work as expected', () {
      final mockItem = Data(cuisineId: 1, itemId: 101);

      viewModel.setCartItems(mockItem);
      expect(viewModel.cartItems.length, 1);

      viewModel.incrementCartValue();
      expect(viewModel.addToCartValue, 1);

      viewModel.decrementCartValue();
      expect(viewModel.addToCartValue, 0);

      viewModel.popLastCartItem();
      expect(viewModel.cartItems, isEmpty);
    });

    test('checkIfFoodExistsInCart returns true for existing item', () {
      final mockItem = Data(cuisineId: 1, itemId: 101);
      viewModel.setCartItems(mockItem);

      final mockDetails = ItemDetailsResponseModel(cuisineId: '1', itemId: 101);
      final exists = viewModel.checkIfFoodExistsInCart(mockDetails);

      expect(exists, true);
    });

    test('checkIfFoodExistsInCart returns false for non-existing item', () {
      final mockItem = Data(cuisineId: 1, itemId: 101);
      viewModel.setCartItems(mockItem);

      final mockDetails = ItemDetailsResponseModel(cuisineId: '2', itemId: 202);
      final exists = viewModel.checkIfFoodExistsInCart(mockDetails);

      expect(exists, false);
    });
  });
}
