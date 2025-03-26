import 'package:get/get.dart';
import 'package:minifood_admin/data/reponsitories/auth_reponsitory.dart';
import 'package:minifood_admin/modules/auth/controller/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => AuthRepository(Get.find()));
    Get.lazyPut(() => AuthController());
  }
}
