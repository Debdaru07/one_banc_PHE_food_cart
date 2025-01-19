// import 'package:flutter_dotenv/flutter_dotenv.dart';


import 'helpers/constants.dart';

class AppUrl {
  var itemsEndPointURL = '${Constants().baseURL}get_item_list';
  var filterEndPointURL = '${Constants().baseURL}get_item_by_filter';
  var itemDetailsEndPointURL = '${Constants().baseURL}get_item_by_id';
  var makePaymentEndPointURL = '${Constants().baseURL}make_payment';
  
}