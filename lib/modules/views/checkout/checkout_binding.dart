import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/cart/cart_controller.dart';
import 'package:minifood_staff/modules/views/orders/order_controller.dart';
import 'package:minifood_staff/modules/views/vouchers/controller/voucher_controller.dart';

class CheckOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<VoucherController>(() => VoucherController());
  }
}
