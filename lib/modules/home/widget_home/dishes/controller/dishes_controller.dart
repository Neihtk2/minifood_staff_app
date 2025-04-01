import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/data/reponsitories/dished_reponsitory.dart';

class DishesController extends GetxController {
  final DishedReponsitoryImpl _repo = DishedReponsitoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<DishedModel> mainDishes = <DishedModel>[].obs;
  final RxList<DishedModel> dessertDishes = <DishedModel>[].obs;
  final RxList<DishedModel> beverageDishes = <DishedModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDishes();
  }

  Future<void> getDishes() async {
    try {
      isLoading.value = true;
      mainDishes.value = await _repo.getDishes('main');
      dessertDishes.value = await _repo.getDishes('dessert');
      beverageDishes.value = await _repo.getDishes('beverage');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDished(String id) async {
    try {
      final response = await _repo.deleteDished(id);
      if (response.statusCode == 201 || response.statusCode == 200) {
        getDishes();
        // clearForm();
        Get.back();
        Get.snackbar(
          'Thành công',
          'Xoá món thành công',
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
    }
  }
}

void _handleError(dynamic e) {
  final message =
      e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
  // Get.snackbar('Error', message);
}
