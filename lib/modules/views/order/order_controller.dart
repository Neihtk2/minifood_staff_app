import 'package:get/get.dart';
import 'package:minifood_admin/core/utils/error/error_func.dart';
import 'package:minifood_admin/data/models/orders_model.dart';
import 'package:minifood_admin/data/reponsitories/order_reponsitory.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';

class OrdersController extends GetxController {
  CartController cartController = Get.find();
  final OrdersRepositoryImpl _repo = OrdersRepositoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<OrdersModel> orders = <OrdersModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> createOrder(
    String customerName,
    String phone,
    String deliveryAddress,
    String paymentMethod,
    int orderTotal,
    String? voucherCode,
  ) async {
    try {
      isLoading.value = true;
      await _repo.creatOrder(
        customerName,
        phone,
        deliveryAddress,
        paymentMethod,
        orderTotal,
        voucherCode,
      );
      await cartController.getCart();
      await getOrders();
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrders(String? status, String id) async {
    try {
      isLoading.value = true;
      await _repo.updateStatus(status, id);
      getOrders();
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrders() async {
    try {
      isLoading.value = true;
      orders.value = await _repo.getOrders();
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
