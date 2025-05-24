import 'package:get/get.dart';
import 'package:minifood_staff/core/utils/error/error_func.dart';
import 'package:minifood_staff/data/models/orders_model.dart';
import 'package:minifood_staff/data/reponsitories/order_reponsitory.dart';
import 'package:minifood_staff/modules/views/cart/cart_controller.dart';

class OrdersController extends GetxController {
  CartController cartController = Get.find();

  final OrdersRepositoryImpl _repo = OrdersRepositoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  // final RxList<OrdersModel> getOrdersDelivery = <OrdersModel>[].obs;
  // final RxList<OrdersModel> getAcceptedDelivery = <OrdersModel>[].obs;
  final RxList<OrdersModel> orders = <OrdersModel>[].obs;
  final RxList<OrdersModel> pending = <OrdersModel>[].obs;
  final RxList<OrdersModel> processing = <OrdersModel>[].obs;
  final RxList<OrdersModel> delivering = <OrdersModel>[].obs;
  final RxList<OrdersModel> completed = <OrdersModel>[].obs;
  final RxList<OrdersModel> cancelled = <OrdersModel>[].obs;
  final RxList<OrdersModel> rejected = <OrdersModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> refreshOrders() async {
    await getOrders();
  }

  Future<void> createOrder(
    String customerName,
    String phone,
    String paymentMethod,
    int orderTotal,
    String? voucherCode,
  ) async {
    try {
      isLoading.value = true;
      await _repo.creatOrder(
        customerName,
        phone,
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

  Future<void> acceptOrderForDelivery(String id) async {
    try {
      isLoading.value = true;
      await _repo.acceptOrderForDelivery(id);
      await getOrders();
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrders() async {
    try {
      isLoading.value = true;
      pending.value = await _repo.getAllOrders('pending');
      processing.value = await _repo.getAllOrders('processing');
      delivering.value = await _repo.getAllOrders('delivering');
      completed.value = await _repo.getAllOrders('completed');
      cancelled.value = await _repo.getAllOrders('cancelled');
      rejected.value = await _repo.getAllOrders('rejected');
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
