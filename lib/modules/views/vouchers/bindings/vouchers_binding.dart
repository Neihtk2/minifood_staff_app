import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/vouchers/controller/voucher_controller.dart';

class VouchersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoucherController());
  }
}
