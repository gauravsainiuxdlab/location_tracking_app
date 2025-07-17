import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  static String handleError(dynamic error) {
    var errorDescription = "";
    switch (error) {
      case DioException.badResponse:
        errorDescription = "Bad Response";
        break;
      case DioExceptionType.connectionError:
        errorDescription = "Connection error";
        break;
      case DioExceptionType.badCertificate:
        errorDescription = "Bad certificate";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "send Time out";
        break;
      case DioExceptionType.cancel:
        errorDescription = "Request cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "Connection timeout";
        break;
      case DioExceptionType.unknown:
        errorDescription = "No internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
    }
    return errorDescription;
  }
}
