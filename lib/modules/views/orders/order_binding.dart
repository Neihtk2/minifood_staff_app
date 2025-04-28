import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/cart/cart_controller.dart';
import 'package:minifood_staff/modules/views/orders/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
    // Get.lazyPut<CartController>(() => CartController());
  }
}
