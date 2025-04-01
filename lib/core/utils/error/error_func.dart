import 'package:dio/dio.dart';
import 'package:get/get.dart';

void handleError(dynamic error) {
  if (error is DioException) {
    Get.snackbar('Error', error.response?.data['message'] ?? error.message);
  } else {
    Get.snackbar('Error', error.toString());
  }
}
