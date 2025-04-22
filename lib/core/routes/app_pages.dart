import 'package:get/get.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/modules/auth/binding/auth_binding.dart';
import 'package:minifood_admin/modules/auth/view/login_screen.dart';
import 'package:minifood_admin/modules/auth/view/sigin_screen.dart';
import 'package:minifood_admin/modules/views/cart/cart_binding.dart';
import 'package:minifood_admin/modules/views/cart/cart_screen.dart';
import 'package:minifood_admin/modules/views/checkout/checkout_binding.dart';
import 'package:minifood_admin/modules/views/checkout/checkout_screen.dart';
import 'package:minifood_admin/modules/views/home/bindings/home_bindings.dart';
import 'package:minifood_admin/modules/views/home/home_screen.dart';
import 'package:minifood_admin/modules/views/order/order_binding.dart';
import 'package:minifood_admin/modules/views/order/order_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: RouterName.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RouterName.REGISTER,
      page: () => SignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RouterName.CHECKOUT,
      page: () => CheckoutScreen(),
      binding: CheckOutBinding(),
    ),
    GetPage(
      name: RouterName.CART,
      page: () => CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: RouterName.ORDERS,
      page: () => OrderListScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: RouterName.HOME,
      page: () => HomeScreen(),
      binding: HomeBindings(),
    ),
  ];
}
