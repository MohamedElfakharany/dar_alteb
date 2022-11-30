import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://hq.orcav.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }
  static Future<Response> getData({
    @required String? url,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'Accept': 'application/json',
    };
    return await dio!.get(
      url!,
      queryParameters: queryParams,
    );
  }

  static Future<Response> postData({
    @required String? url,
    Map<String, dynamic>? query,
    @required Map<String, dynamic>? data,
    String? token,
  }) async {
    if (kDebugMode) {
      print('data from dio helper $data');
    }
    if (kDebugMode) {
      print('url from dio helper $url');
    }
    return await dio!.post(
      url!,
      queryParameters: query,
      data: data,

    );
  }
}
