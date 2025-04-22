import 'package:get/get.dart';
import 'package:minifood_admin/modules/auth/controller/auth_controller.dart';

class ForgotpassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
