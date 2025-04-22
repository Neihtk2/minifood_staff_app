import 'package:get/get.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CartRepository>(() => CartRepository());
    Get.lazyPut<CartController>(() => CartController());
    // Get.lazyPut<ApiService>(() => ApiService());
  }
}
