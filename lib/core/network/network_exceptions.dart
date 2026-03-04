import 'dart:io';

class NetworkExceptions implements Exception {
  final String message;

  NetworkExceptions(this.message);

  factory NetworkExceptions.fromStatusCode(int statusCode, dynamic response) {
    switch (statusCode) {
      case 400:
        return NetworkExceptions("Bad Request");
      case 401:
        return NetworkExceptions("Unauthorized - Please login again");
      case 403:
        return NetworkExceptions("Forbidden");
      case 404:
        return NetworkExceptions("API Not Found");
      case 500:
        return NetworkExceptions("Internal Server Error");
      default:
        return NetworkExceptions("Something went wrong");
    }
  }

  factory NetworkExceptions.fromException(dynamic e) {
    if (e is SocketException) {
      return NetworkExceptions("No Internet Connection");
    } else if (e is HttpException) {
      return NetworkExceptions("HTTP Error");
    } else {
      return NetworkExceptions("Unexpected Error");
    }
  }

  @override
  String toString() => message;
}
