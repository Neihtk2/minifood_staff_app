import 'package:get/get.dart';
import 'package:minifood_staff/core/routes/app_routes.dart';
import 'package:minifood_staff/modules/auth/binding/auth_binding.dart';
import 'package:minifood_staff/modules/auth/view/login_screen.dart';

import 'package:minifood_staff/modules/views/cart/cart_binding.dart';
import 'package:minifood_staff/modules/views/cart/cart_screen.dart';
import 'package:minifood_staff/modules/views/checkout/checkout_binding.dart';
import 'package:minifood_staff/modules/views/checkout/checkout_screen.dart';
import 'package:minifood_staff/modules/views/home/bindings/home_bindings.dart';
import 'package:minifood_staff/modules/views/home/view/home_screen.dart';
import 'package:minifood_staff/modules/views/home/view/home_shipper_screen.dart';
import 'package:minifood_staff/modules/views/shipping/bindings/shipping_binding.dart';
import 'package:minifood_staff/modules/views/shipping/view/shipping_screen.dart';
import 'package:minifood_staff/modules/views/vouchers/bindings/vouchers_binding.dart';
import 'package:minifood_staff/modules/views/vouchers/view/vouchers_view.dart';
import 'package:minifood_staff/modules/views/message/room_list.dart';
import 'package:minifood_staff/modules/views/message/chat_screen.dart' as Chat;

class AppPages {
  static final pages = [
    GetPage(
      name: RouterName.LOGIN,
      page: () => LoginScreen(),
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
      page: () => ShippingScreen(),
      binding: ShippingBinding(),
    ),
    GetPage(
      name: RouterName.HOME,
      page: () => HomeScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: RouterName.SHIPPERHOME,
      page: () => HomeShipperScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: RouterName.VOUCHERS,
      page: () => VouchersListView(),
      binding: VouchersBinding(),
    ),
    GetPage(
      name: RouterName.SUPPORT,
      page: () => RoomListScreen(),
    ),
    GetPage(
      name: '/chat',
      page: () => Chat.ChatScreen(userId: 0), // Placeholder userId
    ),
  ];
}
