import 'package:get/get.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';
import 'package:minifood_admin/modules/views/order/order_controller.dart';
import 'package:minifood_admin/modules/views/vouchers/voucher_controller.dart';

class CheckOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<VoucherController>(() => VoucherController());
  }
}
