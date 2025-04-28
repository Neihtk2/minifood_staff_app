import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/cart/cart_controller.dart';
import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_staff/modules/views/profile/profile_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.putAsync(
      () async => DishesController(),
    ); // Đảm bảo DishesController được tạo trước khi tiếp tục
    Get.putAsync(
      () async => ProfileController(),
    ); // Đảm bảo ProfileController được tạo trước khi tiếp tục
    // Get.putAsync(
    //   () async => CartController(),
    // ); // Đảm bảo CartController được tạo trước khi tiếp tục
  }
}
