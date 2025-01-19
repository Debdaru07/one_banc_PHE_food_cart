import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum RequestState { loading, completed, error }

class ApiService {
  RequestState _state = RequestState.completed;
  String _errorMessage = '';

  RequestState get state => _state;
  String get errorMessage => _errorMessage;

  Future<Response> postRequest<Request, Response>({
    required String url,
    required Map<String, String> headers,
    required Request requestBody,
    required Map<String, dynamic> Function(Request) toJson,
    required Response Function(Map<String, dynamic>) fromJson,
  }) async {
    _setState(RequestState.loading);
    
    headers.addAll({
      'Content-Type': 'application/json',
      'X-Partner-API-Key': dotenv.env['X_PARTNER_API_KEY'] ?? '',
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(toJson(requestBody)),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _setState(RequestState.completed);
        return fromJson(jsonDecode(response.body));
      } else {
        _setState(RequestState.error, errorMessage: response.body);
        return Future.error(response.body);
      }
    } catch (e) {
      _setState(RequestState.error, errorMessage: e.toString());
      return Future.error(e);
    }
  }

  void _setState(RequestState newState, {String errorMessage = ''}) {
    _state = newState;
    _errorMessage = errorMessage;
  }
}
