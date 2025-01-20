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
  final ApiService _apiService;
  FoodItemsVM({ApiService? apiService}) : _apiService = apiService ?? ApiService();

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

  List<String> _cuisineTypes = [];
  List<String> get cuisineTypes => _cuisineTypes;

  setCuisines(List<String> val) {
    _cuisineTypes = val;
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
      setCuisines(getCuisineNames(response));
      setItemsListModel(response);
      _updateState(RequestState.completed);
    } catch (e) {
      _updateState(RequestState.error, errorMessage: e.toString());
    }
  }

  List<String> getCuisineNames(ItemsListModel itemsListModel) {
    List<String> cuisineNames = [];
    if (itemsListModel.cuisines != null) {
      for (var cuisine in itemsListModel.cuisines!) {
        if (cuisine.cuisineName != null) {
          cuisineNames.add(cuisine.cuisineName!);
        }
      }
    }
    return cuisineNames;
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

  ItemsFilterRequestModel? _selectedFilterItems = ItemsFilterRequestModel();
  ItemsFilterRequestModel? get selectedFilterItems => _selectedFilterItems;

  setFilterItems(ItemsFilterRequestModel? val){
    _selectedFilterItems = val;
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
      setItemsListModel(convertItemsFilterToItemsList(response));
      _updateState(RequestState.completed);
    } catch (e) {
      _updateState(RequestState.error, errorMessage: e.toString());
    }
  }

  ItemsListModel convertItemsFilterToItemsList(ItemsFilterModel filterModel) {
    return ItemsListModel(
      responseCode: filterModel.responseCode,
      outcomeCode: filterModel.outcomeCode,
      responseMessage: filterModel.responseMessage,
      page: 1, 
      count: 10,
      totalPages: 1,
      totalItems: filterModel.cuisines?.fold(0, (sum, cuisine) => sum! + (cuisine.items?.length ?? 0)) ?? 0,
      cuisines: filterModel.cuisines?.map((cuisine) {
        return Cuisines(
          cuisineId: cuisine.cuisineId?.toString(), // Adjust type if necessary
          cuisineName: cuisine.cuisineName,
          cuisineImageUrl: cuisine.cuisineImageUrl,
          items: cuisine.items?.map((item) {
            return Items(
              id: item.id?.toString(), // Adjust type if necessary
              name: item.name,
              imageUrl: item.imageUrl,
              price: '', // Assuming you want to keep price, adjust if needed
              rating: '', // Assuming you want to keep rating, adjust if needed
            );
          }).toList(),
        );
      }).toList(),
      timestamp: filterModel.timestamp,
      requesterIp: filterModel.requesterIp,
      timetaken: filterModel.timetaken,
    );
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
        requestBody: consolidateItems(request),
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

  MakePaymentRequestModel consolidateItems(MakePaymentRequestModel model) {
    if (model.data == null || model.data!.isEmpty) {
      return model;
    }
    final Map<String, Data> uniqueItemsMap = {};
    for (var item in model.data!) {
      String key = '${item.cuisineId}-${item.itemId}';
      if (uniqueItemsMap.containsKey(key)) {
        uniqueItemsMap[key]!.itemQuantity = (uniqueItemsMap[key]!.itemQuantity ?? 0) + (item.itemQuantity ?? 0);
      } else {
        uniqueItemsMap[key] = Data(
          cuisineId: item.cuisineId,
          itemId: item.itemId,
          itemPrice: item.itemPrice,
          itemQuantity: item.itemQuantity,
        );
      }
    }
    model.data = uniqueItemsMap.values.toList();
    model.calculateTotalAmount();
    model.calculateTotalItems();
    return model;
  }

}
