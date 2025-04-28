import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/data/models/dished_model.dart';
import 'package:minifood_staff/data/reponsitories/cart_reponsitory.dart';

class CartController extends GetxController {
  final CartRepositoryImpl _repo = CartRepositoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt total = 0.obs;
  var filteredCartItem = <DishedModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getCart();
  }

  Future<void> getCart() async {
    String? token = GetStorage().read(StorageConstants.accessToken);
    if (token == null || token.isEmpty) {
      error.value = "Bạn chưa đăng nhập!";
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;
      var fetchedCartData = await _repo.getCart();
      filteredCartItem.assignAll(fetchedCartData);
      error.value = '';
    } catch (e) {
      error.value = "Lỗi khi tải giỏ hàng: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String? status, String id) async {
    try {
      isLoading.value = true;
      await _repo.updateStatus(status, id);
      getCart();
    } catch (e) {
      error.value = "Lỗi khi cập nhật trạng thái: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(String id, int quantity) async {
    try {
      isLoading.value = true;
      await _repo.addToCart(id, quantity);
      getCart();
    } catch (e) {
      error.value = "Lỗi khi thêm món vào giỏ hàng: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String id) async {
    try {
      isLoading.value = true;
      await _repo.removeFromCart(id);
      getCart();
    } catch (e) {
      error.value = "Lỗi khi xóa món khỏi giỏ hàng: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCartItem(String id, int quantity) async {
    try {
      isLoading.value = true;
      await _repo.updateCartItem(id, quantity);
      getCart();
    } catch (e) {
      error.value = "Lỗi khi cập nhật món trong giỏ hàng: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
