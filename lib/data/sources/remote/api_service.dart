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
  // late Dio dio;
  // @override
  // void onInit() {
  //   super.onInit();
  //   dio = Dio(
  //     BaseOptions(
  //       baseUrl: Endpoints.baseUrl,
  //       connectTimeout: const Duration(seconds: 30),
  //       receiveTimeout: const Duration(seconds: 30),
  //     ),
  //   );
  // }
}
