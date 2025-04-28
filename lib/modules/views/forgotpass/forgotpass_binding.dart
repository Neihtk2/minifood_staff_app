import 'package:get/get.dart';
import 'package:minifood_staff/modules/auth/controller/auth_controller.dart';

class ForgotpassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
