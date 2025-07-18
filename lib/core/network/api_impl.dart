import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/api_url_constants.dart';
import '../helper/app_logger.dart';
import 'api_services.dart';
import 'data_state.dart';
import 'network_exception.dart';

class ApiImpl extends ApiServices {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: ApiUrlConstants.baseUrl,
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      receiveDataWhenStatusError: true,
      validateStatus: (status) {
        return status! <= 500;
      }));
      
      

  //
  // @override
  // Future<dynamic> addUser(
  //     {required String email,
  //       required String password,
  //       required String userName,
  //       required String Name,
  //       required String DeviceId,
  //       required String DeviceName,
  //     }) async {
  //   var data = jsonEncode({
  //     "phone_number": userName,
  //     "email": email,
  //     "user_name": Name,
  //     "password": password,
  //     "device_id":DeviceId,
  //     "device_name":DeviceName,
  //   });
  //
  //   try {
  //     String url = ApiUrlConstants.userRegister;
  //     AppLogger.log(" url $url");
  //     AppLogger.log(" url $data");
  //     Response response = await _dio.post(url, data: data);
  //     if (response.statusCode == 200) {
  //       AppLogger.log("response in API impl: ${response.data}");
  //       return DataSuccess(response.data);
  //     } else if (response.statusCode == 404) {
  //       return DataFailed(
  //           error: response.data['message'], errorCode: response.statusCode);
  //     } else if (response.statusCode == 500) {
  //       return DataFailed(
  //           error: response.data['message'], errorCode: response.statusCode);
  //     } else {
  //       AppLogger.log(response.data['message']);
  //       AppLogger.logError(
  //           " response: ${response.statusCode} ${response.statusMessage}");
  //       return DataFailed(error: response.data['message']);
  //     }
  //   } catch (e) {
  //     var errorDescription = "";
  //     if (e is DioException) {
  //       AppLogger.log(e.type);
  //       errorDescription = DioExceptions.handleError(e.type);
  //     } else {
  //       errorDescription = 'Unexpected error occurred';
  //     }
  //
  //     return DataFailed(error: errorDescription);
  //   }
  // }
  //
  //
  // @override
  // Future<dynamic> login({
  //   required String email,
  //   required String password,
  //   required String deviceId,
  // }) async
  // {
  //   var data = jsonEncode({"email": email, "password": password,"device_id":deviceId});
  //
  //   try {
  //     String url = ApiUrlConstants.login;
  //     AppLogger.log(" url $url");
  //     AppLogger.log(" data $data");
  //     Response response = await _dio.post(url, data: data);
  //     if (response.statusCode == 200) {
  //       AppLogger.log("response in API impl: ${response.data}");
  //       return DataSuccess(response.data);
  //     } else if (response.statusCode == 400) {
  //       return DataFailed(
  //           error: response.data['message'], errorCode: response.statusCode);
  //     } else if (response.statusCode == 202) {
  //       return DataSuccess(response.data);
  //     }
  //     else if (response.statusCode == 500) {
  //       return DataFailed(
  //           error: response.data['message'], errorCode: response.statusCode);
  //     } else {
  //       AppLogger.log(response.data['message']);
  //
  //       AppLogger.logError(
  //           " response: ${response.statusCode} ${response.statusMessage}");
  //       return DataFailed(
  //           error: response.statusMessage, errorCode: response.statusCode);
  //     }
  //   } catch (e) {
  //     var errorDescription = "";
  //     if (e is DioException) {
  //       AppLogger.log(e.type);
  //       errorDescription = DioExceptions.handleError(e.type);
  //     } else {
  //       errorDescription = 'Unexpected error occurred';
  //     }
  //
  //     return DataFailed(error: errorDescription);
  //   }
  // }
  //

  // @override
  // Future<dynamic> getUsers() async {
  //   try {
  //     String url = ApiUrlConstants.users;
  //     AppLogger.log(" url $url");
  //     Response response = await _dio.get(url);
  //     if (response.statusCode == 200) {
  //       AppLogger.log("response in API impl: ${response.data}");
  //       return DataSuccess(response.data);
  //     } else if (response.statusCode == 404) {
  //       return DataFailed(
  //           error: response.data['message'], errorCode: response.statusCode);
  //     } else if (response.statusCode == 500) {
  //       return DataFailed(
  //           error: response.data['message'], errorCode: response.statusCode);
  //     } else {
  //       AppLogger.log(response.data['message']);
  //       AppLogger.logError(
  //           " response: ${response.statusCode} ${response.statusMessage}");
  //       return DataFailed(error: response.data['message']);
  //     }
  //   } catch (e) {
  //     var errorDescription = "";
  //     if (e is DioException) {
  //       AppLogger.log(e.type);
  //       errorDescription = DioExceptions.handleError(e.type);
  //     } else {
  //       errorDescription = 'Unexpected error occurred';
  //     }

  //     return DataFailed(error: errorDescription);
  //   }
  // }

}