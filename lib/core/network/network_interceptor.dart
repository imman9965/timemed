import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timesmed_project/core/storage/secure_storage.dart';

class NetworkInterceptor {
  final SecureStorage _storage = SecureStorage();

  Future<Map<String, String>> getHeaders() async {
    final token = await _storage.getToken();

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  void logRequest(String method, String url, dynamic body) {
    print("---- API REQUEST ----");
    print("Method: $method");
    print("URL: $url");
    print("Body: $body");
  }

  void logResponse(http.Response response) {
    print("---- API RESPONSE ----");
    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");
  }
}
