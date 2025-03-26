// 2. Binding (lib/app/bindings/dish_binding.dart)
import 'package:get/get.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/controller/add_dishes_controller.dart';

class DishBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DishController());
  }
}
