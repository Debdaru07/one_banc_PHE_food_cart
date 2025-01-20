import 'package:flutter/material.dart';
import '../app_url.dart';
import '../model/request_models/item_details_request_body_mode.l.dart';
import '../model/request_models/item_filter_request_model.dart';
import '../model/request_models/item_list_request_body_model.dart';
import '../model/request_models/make_payment_request_model.dart';
import '../model/response_models/item_details_model.dart';
import '../model/response_models/item_filter_model.dart';
import '../model/response_models/item_list_model.dart';
import '../model/response_models/make_payment_model.dart';
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

  // Function 1: Fetch all items
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

  // Function 2: Fetch item by ID
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

  ItemsFilterModel? _itemsFilterModel;
  ItemsFilterModel? get itemsFilterModel => _itemsFilterModel;

  setItemsFilterModel(ItemsFilterModel? val) {
    _itemsFilterModel = val;
    notifyListeners();
  }

  // Function 3: Fetch item by filter
  Future<void> getItemByFilter(ItemsFilterRequestModel request) async {
    var url = AppUrl().filterEndPointURL; 
    _updateState(RequestState.loading);
    try {
      final response = await _apiService.postRequest<ItemsFilterRequestModel, ItemsFilterModel>(
        url: url,
        headers: {
          'X-Forward-Proxy-Action': 'get_item_by_filter'
        },
        requestBody: request,
        toJson: (req) => req.toJson(),
        fromJson: (json) => ItemsFilterModel.fromJson(json),
      );
      setItemsFilterModel(response);
      _updateState(RequestState.completed);
    } catch (e) {
      _updateState(RequestState.error, errorMessage: e.toString());
    }
  }


  MakePaymentResponseModel? _makePaymentResponseModel;
  MakePaymentResponseModel? get makePaymentResponseModel => _makePaymentResponseModel;
  
  setmakePaymentResponseModel(MakePaymentResponseModel val) {
    _makePaymentResponseModel = val;
    notifyListeners();
  }

  // Function 4: Make payment
  Future<void> makePayment(MakePaymentRequestModel request) async {
    var url = AppUrl().makePaymentEndPointURL; 
    _updateState(RequestState.loading);
    try {
      final response = await _apiService.postRequest<MakePaymentRequestModel, MakePaymentResponseModel>(
        url: url,
        headers: {
          'X-Forward-Proxy-Action': 'make_payment'
        },
        requestBody: request,
        toJson: (req) => req.toJson(),
        fromJson: (json) => MakePaymentResponseModel.fromJson(json), 
      );
      setmakePaymentResponseModel(response);
      _updateState(RequestState.completed);
    } catch (e) {
      _updateState(RequestState.error, errorMessage: e.toString());
    }
  }

  int _addToCart = 0;
  int get addToCartValue => _addToCart;

  setCartValue(int val) {
    _addToCart = val;
    notifyListeners();
  }

  incrementCartValue() {
    _addToCart += 1;
    notifyListeners();
  }

  decrementCartValue() {
    _addToCart -= 1;
    notifyListeners();
  }

  List<Data> _cartItems = []; 
  List<Data> get cartItems => _cartItems;

  setCartItems(Data val) {
    cartItems.add(val);
    notifyListeners();
  }

  removeAllCartItems() {
    _cartItems = [];
    notifyListeners();
  }

  popLastCartItem() {
    cartItems.removeLast();
    notifyListeners();
  }

  bool checkIfFoodExistsInCart(ItemDetailsResponseModel? element){
    bool check = false;
    cartItems.forEach((obj) {
      if('${obj.cuisineId}' == '${element?.cuisineId}' && '${obj.itemId}' == '${element?.itemId}') {
        check = true;
      }
    });
    return check;
  }
}
