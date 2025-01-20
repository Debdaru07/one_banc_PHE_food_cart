import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:munch/model/request_models/item_details_request_body_mode.l.dart';
import 'package:munch/model/request_models/item_filter_request_model.dart';
import 'package:munch/model/request_models/item_list_request_body_model.dart';
import 'package:munch/model/request_models/make_payment_request_model.dart';
import 'package:munch/model/response_models/item_details_model.dart';
import 'package:munch/model/response_models/item_filter_model.dart';
import 'package:munch/model/response_models/item_list_model.dart';
import 'package:munch/model/response_models/make_payment_model.dart';
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

    test('getItemById updates state and itemsListModel on success', () async {
      // Mock data
      final mockRequest = ItemListDetailsRequestBodyModel();
      final mockResponse = ItemDetailsResponseModel(responseCode: 200);
      when(mockApiService.postRequest<ItemListDetailsRequestBodyModel, ItemDetailsResponseModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockResponse);


      await viewModel.getItemById(mockRequest);

      expect(viewModel.state, RequestState.completed);
      expect(viewModel.itemDetails, isNotNull);
      expect(viewModel.itemDetails?.responseCode, 200);
    });

    test('getItemById handles errors', () async {
      final mockRequest = ItemListDetailsRequestBodyModel();
      final mockErrorMessage = 'Network error occurred';

      when(mockApiService.postRequest<ItemListRequestModel, ItemsListModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenThrow(Exception(mockErrorMessage));

      await viewModel.getItemById(mockRequest);

      expect(viewModel.state, RequestState.error);
      expect(viewModel.errorMessage, contains('Network error occurred'));
    });

    test('getItemByFilter updates state and itemsListModel on success', () async {
      // Mock data
      final mockRequest = ItemsFilterRequestModel();
      final mockResponse = ItemsFilterModel(responseCode: 200);
      when(mockApiService.postRequest<ItemsFilterRequestModel, ItemsFilterModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockResponse);


      await viewModel.getItemByFilter(mockRequest);

      expect(viewModel.state, RequestState.completed);
      expect(viewModel.itemsFilterModel, isNotNull);
      expect(viewModel.itemsFilterModel?.responseCode, 200);
    });

    test('getItemByFilter handles errors', () async {
      final mockRequest = ItemsFilterRequestModel();
      final mockErrorMessage = 'Network error occurred';

      when(mockApiService.postRequest<ItemsFilterRequestModel, ItemsFilterModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenThrow(Exception(mockErrorMessage));

      await viewModel.getItemByFilter(mockRequest);

      expect(viewModel.state, RequestState.error);
      expect(viewModel.errorMessage, contains('Network error occurred'));
    });

    test('makePayment updates state and itemsListModel on success', () async {
      // Mock data
      final mockRequest = MakePaymentRequestModel();
      final mockResponse = MakePaymentResponseModel(responseCode: 200);
      when(mockApiService.postRequest<MakePaymentRequestModel, MakePaymentResponseModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockResponse);


      await viewModel.makePayment(mockRequest);

      expect(viewModel.state, RequestState.completed);
      expect(viewModel.makePaymentResponseModel, isNotNull);
      expect(viewModel.makePaymentResponseModel?.responseCode, 200);
    });

    test('makePayment handles errors', () async {
      final mockRequest = MakePaymentRequestModel();
      final mockErrorMessage = 'Network error occurred';

      when(mockApiService.postRequest<MakePaymentRequestModel, MakePaymentResponseModel>(
        url: anyNamed('url'),
        headers: anyNamed('headers'),
        requestBody: anyNamed('requestBody'),
        toJson: anyNamed('toJson'),
        fromJson: anyNamed('fromJson'),
      )).thenThrow(Exception(mockErrorMessage));

      await viewModel.makePayment(mockRequest);

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

    test('should return model as is when data is empty', () {
      final model = MakePaymentRequestModel(data: []);
      final result = viewModel.consolidateItems(model);
      
      expect(result.data, []);
    });

    test('should consolidate items with same cuisineId and itemId', () {
      final model = MakePaymentRequestModel(
        data: [
          Data(cuisineId: 1, itemId: 101, itemPrice: 100, itemQuantity: 2),
          Data(cuisineId: 1, itemId: 101, itemPrice: 100, itemQuantity: 3),
        ],
      );

      final result = viewModel.consolidateItems(model);

      expect(result.data!.length, 1);
      expect(result.data![0].itemQuantity, 5);
    });

    test('should not change unique items', () {
      final model = MakePaymentRequestModel(
        data: [
          Data(cuisineId: 1, itemId: 101, itemPrice: 100, itemQuantity: 2),
          Data(cuisineId: 2, itemId: 102, itemPrice: 200, itemQuantity: 1),
        ],
      );

      final result = viewModel.consolidateItems(model);

      expect(result.data!.length, 2);
      expect(result.data![0].itemQuantity, 2);
      expect(result.data![1].itemQuantity, 1);
    });

    test('should call calculateTotalAmount and calculateTotalItems', () {
      final model = MakePaymentRequestModel(
        data: [
          Data(cuisineId: 1, itemId: 101, itemPrice: 100, itemQuantity: 2),
        ],
      );

      final result = viewModel.consolidateItems(model);
      expect(result.totalAmount, isNotNull);
      expect(result.totalItems, isNotNull);
    });

    
  });
}
