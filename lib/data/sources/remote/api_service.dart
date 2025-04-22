import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:minifood_admin/core/constants/api_constants.dart';

class ApiService extends GetxService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  ApiService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add any request interceptors here
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Add any response interceptors here
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          // Handle errors here
          return handler.next(e);
        },
      ),
    );
  }
}
