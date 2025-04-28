import 'package:get/get.dart';

import 'package:minifood_staff/modules/auth/controller/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => AuthRepository(Get.find()));
    Get.lazyPut(() => AuthController());
  }
}
