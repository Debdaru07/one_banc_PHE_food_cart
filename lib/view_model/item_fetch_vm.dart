import 'package:flutter/material.dart';
import '../app_url.dart';
import '../model/request_models/item_details_request_body_mode.l.dart';
import '../model/request_models/item_list_request_body_model.dart';
import '../model/response_models/item_details_model.dart';
import '../model/response_models/item_list_model.dart';
import '../service/common_post_api_handler.dart';

class FoodItemsVM extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  RequestState _state = RequestState.completed;
  String _errorMessage = '';

  RequestState get state => _state;
  String get errorMessage => _errorMessage;

  ItemsListModel? _itemsListModel;
  ItemsListModel? get itemsListModel => _itemsListModel;
  
  setItemsListModel(ItemsListModel? val) {
    _itemsListModel = val;
    notifyListeners();
  }

  void _updateState(RequestState newState, {String errorMessage = ''}) {
    _state = newState;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  Future<void> fetchItemList(ItemListRequestModel requestModel) async {
    var url = AppUrl().itemsEndPointURL;
    _updateState(RequestState.loading);
    try {
      final response = await _apiService.postRequest<ItemListRequestModel, ItemsListModel>(
        url: url,
        headers: {
          'X-Forward-Proxy-Action': 'get_item_list'
        }, 
        requestBody: requestModel,
        toJson: (_) => requestModel.toJson(),
        fromJson: (json) => ItemsListModel.fromJson(json),
      );
      setItemsListModel(response);
      _updateState(RequestState.completed);
    } catch (e) {
      _updateState(RequestState.error, errorMessage: e.toString());
    }
  }

  ItemDetailsResponseModel? _itemDetails;
  ItemDetailsResponseModel? get itemDetails => _itemDetails;
  
  setItemDetails(ItemDetailsResponseModel? val) {
    _itemDetails = val;
    notifyListeners();
  }

  // Function 2: Fetch item by filter
  Future<void> getItemById(ItemListDetailsRequestBodyModel request) async {
    var url = AppUrl().itemDetailsEndPointURL;
    _updateState(RequestState.loading);
    try {
      final response = await _apiService.postRequest<ItemListDetailsRequestBodyModel, ItemDetailsResponseModel>(
        url: url,
        headers: {
          'X-Forward-Proxy-Action': 'get_item_by_id'
        },
        requestBody: request,
        toJson: (req) => req.toJson(),
        fromJson: (json) => ItemDetailsResponseModel.fromJson(json),
      );
      setItemDetails(response);
      _updateState(RequestState.completed);
    } catch (e) {
      _updateState(RequestState.error, errorMessage: e.toString());
    }
  }

  // // Function 3: Fetch item by ID
  // Future<void> getItemById(IdRequest request) async {
  //   const url = 'https://uat.onebanc.ai/emulator/interview/get_item_by_id';
  //   try {
  //     final response = await _apiService.postRequest<IdRequest, ItemResponse>(
  //       url: url,
  //       headers: {}, // Add any custom headers if required
  //       requestBody: request,
  //       toJson: (req) => req.toJson(), // Convert request model to JSON
  //       fromJson: (json) => ItemResponse.fromJson(json), // Parse response JSON
  //     );
  //     _responseData = response; // Save response
  //     _updateState(RequestState.completed);
  //   } catch (e) {
  //     _updateState(RequestState.error, errorMessage: e.toString());
  //   }
  // }

  // // Function 4: Make payment
  // Future<void> makePayment(PaymentRequest request) async {
  //   const url = 'https://uat.onebanc.ai/emulator/interview/make_payment';
  //   try {
  //     final response = await _apiService.postRequest<PaymentRequest, PaymentResponse>(
  //       url: url,
  //       headers: {}, // Add any custom headers if required
  //       requestBody: request,
  //       toJson: (req) => req.toJson(), // Convert request model to JSON
  //       fromJson: (json) => PaymentResponse.fromJson(json), // Parse response JSON
  //     );
  //     _responseData = response; // Save response
  //     _updateState(RequestState.completed);
  //   } catch (e) {
  //     _updateState(RequestState.error, errorMessage: e.toString());
  //   }
  // }
}
