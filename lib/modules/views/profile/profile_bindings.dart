import 'package:get/get.dart';
import 'package:minifood_admin/modules/views/profile/profile_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
