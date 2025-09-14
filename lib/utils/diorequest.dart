import 'dart:math';

import 'package:dio/dio.dart';
// import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' as debugPrint;
import 'package:get/route_manager.dart';

class Diorequest {
  final dio = Dio();

  String generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<dynamic> get(String endpoint) async {
    try {
      var header = {
        'Content-Type': Headers.jsonContentType,
        'Authorization': 'Bearer token'
      };
      final options = Options(headers: header);
      String url = 'apibaseurl$endpoint';
      if (endpoint.contains("https")) {
        url = endpoint;
      }
      Response response = await dio.get(url, options: options);
      if (response.statusCode == 200) {
        return checktoken(response);
      } else if (response.statusCode == 201) {
        logout();
        return {
          "success": false,
          "message": "Try and login again",
          "status": "false"
        };
      }
    } on DioException catch (e) {
      debugPrint.debugPrint("response error");
      debugPrint.debugPrint(e.toString());
      debugPrint.debugPrint(e.message);
      return {
        "success": false,
        "message": "Kindly Check your internet \n error: ${e.message}",
        "status": "false"
      };
    }
  }

  // var enableencryption = false;
  Future<dynamic> post(String endpoint, var data) async {
    String url = 'apibaseurl$endpoint';
    if (endpoint.contains("https")) {
      url = endpoint;
    }
    String Ivstring = generateRandomString(16);
    // String keystring = dotenv.env['API_KEY'] ?? 'API_KEY not found';
    String keystring = "12345678901234567890123456789012";
    var payload = data;
    // if(enableencryption) {
    //   payload = {
    //     "data": encrpted(data,keystring,Ivstring),
    //   };
    // }
    var header = {
      'Content-Type': Headers.jsonContentType,
      'Authorization': 'Bearer token',
      'timestamp': Ivstring,
    };
    debugPrint.debugPrint(url);
    // debugPrint.debugPrint("headers: $header");
    // debugPrint.debugPrint(data.toMap());
    // debugPrint.debugPrint(payload.toMap());
    // // Interceptor for encrypting request data
    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) async {
    //     final encryptedData = encryptData(options.data, secretkey);
    //     options.data = encryptedData;
    //     return handler.next(options);
    //   },
    // ));
    // // Interceptor for decrypting response data
    // dio.interceptors.add(InterceptorsWrapper(
    //   onResponse: (response, handler) async {
    //     final decryptedData = decryptData(response.data, secretkey);
    //     response.data = decryptedData;
    //     return handler.next(response);
    //   },
    // ));
    try {
      Response response;
      final options = Options(
        headers: header,
      );
      response = await dio.post(url, options: options, data: payload);
      debugPrint.debugPrint(response.statusCode.toString());
      debugPrint.debugPrint(response.toString());
      debugPrint.debugPrint(response.statusMessage.toString());
      if (response.statusCode == 200) {
        //   if(response is String){
        return {
          "success": true,
          "message": response,
          "status": response == "upload-success"
        };
        // }else {
        //   return  checktoken(response);
        // }
      } else if (response.statusCode == 201) {
        logout();
        return {
          "success": false,
          "message": "Try and login again",
          "status": "false"
        };
      }
    } on DioException catch (e) {
      debugPrint.debugPrint("error");
      debugPrint.debugPrint(e.message);
      return {
        "success": false,
        "message": "Kindly Check your internet \n error: ${e.message}",
        "status": "false"
      };
    }
  }

  dynamic checktoken(Response response) {
    if (response.data["status"] == 0 &&
            response.data["message"] == "Kindly login your account." ||
        response.data["message"] == "Unauthorized!") {
      logout();
      return response.data;
    } else {
      return response.data;
    }
  }

  logout() async {
    // await getstorage().remove("token");
    Get.offAllNamed("/login");
  }
}
