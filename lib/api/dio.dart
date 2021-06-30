import 'package:dio/dio.dart';
import 'package:min_poetry_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

var dio = new Dio();

class DioInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token') ?? '';
    options.headers['Authorization'] = 'Bearer ' + token;
    return super.onRequest(options);
  }
}

class DioHttp {
  static Future get(String url, Map<String, dynamic> params) async {
    var response;
    dio.interceptors.add(new DioInterceptors());
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    dynamic statusCode = response.data['statusCode'] ?? 500;
    if (statusCode == 401) {
      navigatorKey.currentState.pushNamed('/login');
    } else {
      return response.data;
    }
  }

  static Future post(String url, Map<String, dynamic> params) async {
    dio.interceptors.add(DioInterceptors());
    var response = await dio.post(url, data: params);
    print('res.data$response.data');
    dynamic statusCode = response.data['statusCode'] ?? 500;
    if (statusCode == 401) {
      navigatorKey.currentState.pushNamed('/login');
    } else {
      return response.data;
    }
  }
}
