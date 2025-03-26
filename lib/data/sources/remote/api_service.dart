import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:http_parser/http_parser.dart';
import 'package:minifood_admin/core/constants/api_constants.dart';
import 'package:path/path.dart' as path;

class ApiService extends Get.GetxService {
  // final Dio dio = Dio(
  //   BaseOptions(
  //     baseUrl: Endpoints.baseUrl,
  //     connectTimeout: const Duration(seconds: 30),
  //     receiveTimeout: const Duration(seconds: 30),
  //   ),
  // );
  late Dio dio;
  @override
  void onInit() {
    super.onInit();
    dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<Response> getUsers() async {
    return await dio.get(Endpoints.getAllUsers);
  }

  Future<Response> getTopDished() async {
    return await dio.get(Endpoints.topDishes);
  }
}
