// lib/presentation/controllers/auth_controller.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/data/models/auth_model.dart';
import 'package:minifood_admin/data/reponsitories/auth_reponsitory.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository.instance;
  // final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isPasswordHidden = false.obs;
  final box = GetStorage();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        final AuthModel? req = await _repo.login(email, password);
        if (req != null) {
          print("Phản hồi API: ${req.mess}");
          _saveTokens(req.token);
          Get.offAllNamed(RouterName.HOME);
        }
        // else {
        //   Get.snackbar('Error', 'Login failed');
        // }
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String render,
    String address,
  ) async {
    isLoading.value = true;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // final response = await _apiService.LoginApp(username, password);
        final AuthModel? req = await _repo.register(name, email, password);
        if (req != null) {
          _saveTokens(req.token);
          Get.toNamed(RouterName.HOME);
        } else {
          Get.snackbar('Error', 'Login failed');
        }
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _saveTokens(String? accessToken) {
    if (accessToken != null) {
      box.write(StorageConstants.accessToken, accessToken);
      // box.write(MyConfig.REFRESH_TOKEN, refreshToken);
    }
  }

  Future<void> forgotpass(String email) async {}
}

void _handleError(dynamic e) {
  final message =
      e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
  // Get.snackbar('Error', message);
}
