import 'package:dio/dio.dart';
import 'package:get/get.dart';

void handleError(dynamic error) {
  if (error is DioException) {
    Get.snackbar('Lỗi', error.response?.data['message'] ?? error.message);
  } else {
    Get.snackbar('Lỗi', error.toString());
  }
}
