import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/core/utils/push_image/pick_image.dart';
import 'package:minifood_admin/data/reponsitories/dished_reponsitory.dart';

class DishController extends GetxController {
  final DishedReponsitoryImpl dishedReponsitoryImpl =
      DishedReponsitoryImpl.instance;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString category = ''.obs;
  final RxBool isLoading = false.obs;
  final box = GetStorage();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<String> categories = ['main', 'beverage', 'dessert'];
  Future<void> selectImage() async {
    final image = await pickImage();
    if (image != null) {
      selectedImage.value = image;
    }
  }

  Future<void> createDish() async {
    // if (!isValidInput()) return;

    try {
      isLoading.value = true;
      final response = await dishedReponsitoryImpl.createDish(
        name: nameController.text.trim(),
        price: int.parse(priceController.text.trim()),
        category: category.value,
        imageFile: selectedImage.value!,
        token: box.read(StorageConstants.accessToken),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        clearForm();
        Get.back();
        Get.snackbar(
          'Thành công',
          'Thêm món thành công',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception(response.data['message'] ?? 'Lỗi không xác định');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      Get.snackbar(
        'Lỗi API',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool isValidInput() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        category.isEmpty ||
        selectedImage.value == null) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng điền đầy đủ thông tin',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  void clearForm() {
    nameController.clear();
    priceController.clear();
    category.value = '';
    selectedImage.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
