import 'package:get/get.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/modules/auth/binding/auth_binding.dart';
import 'package:minifood_admin/modules/auth/view/login_screen.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/bindings/add_dished_binding.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/view/add_dish_screen.dart';
import 'package:minifood_admin/modules/home/widget_home/view/home_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RouterName.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RouterName.DISHEDADD,
      page: () => const AddDishView(),
      binding: DishBinding(),
    ),
    GetPage(
      name: RouterName.HOME,
      page: () => HomeScreen(),
      // binding: AuthBinding(),
    ),
  ];
}
