import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timesmed_project/core/config/app_config.dart';
import 'network_interceptor.dart';
import 'network_exceptions.dart';

class ApiClient {
  final NetworkInterceptor _interceptor = NetworkInterceptor();

  String get baseUrl => AppConfig.instance.baseUrl;

  Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _interceptor.getHeaders();
      final url = Uri.parse("$baseUrl$endpoint");

      _interceptor.logRequest("GET", url.toString(), null);

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      _interceptor.logResponse(response);

      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.fromException(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final headers = await _interceptor.getHeaders();
      final url = Uri.parse("$baseUrl$endpoint");

      _interceptor.logRequest("POST", url.toString(), body);

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      _interceptor.logResponse(response);

      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.fromException(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final headers = await _interceptor.getHeaders();
      final url = Uri.parse("$baseUrl$endpoint");

      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.fromException(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final headers = await _interceptor.getHeaders();
      final url = Uri.parse("$baseUrl$endpoint");

      final response = await http
          .delete(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      throw NetworkExceptions.fromException(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw NetworkExceptions.fromStatusCode(
        response.statusCode,
        response.body,
      );
    }
  }
}
