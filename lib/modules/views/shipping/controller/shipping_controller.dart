import 'package:get/get.dart';
import 'package:minifood_staff/core/utils/error/error_func.dart';
import 'package:minifood_staff/data/models/orders_model.dart';
import 'package:minifood_staff/data/reponsitories/order_reponsitory.dart';

class ShippingController extends GetxController {
  final OrdersRepositoryImpl _repo = OrdersRepositoryImpl.instance;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<OrdersModel> getOrdersDelivery = <OrdersModel>[].obs;
  final RxList<OrdersModel> getAcceptedDelivery = <OrdersModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> refreshOrders() async {
    await getOrders();
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
      getOrdersDelivery.value = await _repo.getPendingDelivery();
      getAcceptedDelivery.value = await _repo.getAcceptedDeliveryOrders();
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
