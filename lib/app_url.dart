import 'package:flutter_dotenv/flutter_dotenv.dart';


class AppUrl {
  var itemEndPointURL = '${dotenv.env['baseURL'] ?? ''}get_item_list';
  var filterEndPointURL = '${dotenv.env['baseURL'] ?? ''}get_item_by_filter';
  var itemDetailsEndPointURL = '${dotenv.env['baseURL'] ?? ''}get_item_by_id';
  var makePaymentEndPointURL = '${dotenv.env['baseURL'] ?? ''}make_payment';
  
}