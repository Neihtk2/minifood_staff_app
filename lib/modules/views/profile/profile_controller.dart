import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/core/routes/app_routes.dart';
import 'package:minifood_staff/core/utils/error/error_func.dart';
import 'package:minifood_staff/data/models/user_model.dart';
import 'package:minifood_staff/data/reponsitories/users_reponsitory.dart';

class ProfileController extends GetxController {
  final UsersRepositoryImpl _repo = UsersRepositoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<UserModel> profile = UserModel().obs;
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();

    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      final user = await _repo.profile();
      if (user != null) {
        profile.value = user;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserModel user) async {
    try {
      isLoading.value = true;
      await _repo.updateProfile(user);
      profile.value = user;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await box.remove(StorageConstants.accessToken);
      Get.offAllNamed(RouterName.LOGIN);
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> changePassword(
    TextEditingController oldPassword,
    TextEditingController newPassword,
  ) async {
    try {
      isLoading.value = true;
      final response = await _repo.changePassword(
        oldPassword.text,
        newPassword.text,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        oldPassword.clear();
        newPassword.clear();
        Get.snackbar('Thành công', 'Đổi mật khẩu thành công');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
