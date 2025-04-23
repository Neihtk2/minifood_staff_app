import 'package:get/get.dart';
import 'package:minifood_admin/data/models/voucher_model.dart';
import 'package:minifood_admin/data/reponsitories/vouchers_reponsitory.dart';

class VoucherController extends GetxController {
  final VouchersReponsitoryImpl repo = VouchersReponsitoryImpl.instance;
  final RxList<Voucher> orders = <Voucher>[].obs;
  final RxInt orderTotal = 0.obs;
  final selectedVoucher = Rxn<Voucher>();
  final voucherCode = ''.obs;
  final discountAmount = 0.obs;
  final isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getVouchersbyTotal(10000000);
  }

  Future<void> getVouchersbyTotal(int total) async {
    try {
      isLoading.value = true;
      orderTotal.value = total;
      final vouchers = await repo.getAllVouchers(orderTotal.value);
      orders.assignAll(vouchers);
    } finally {
      isLoading.value = false;
    }
  }

  void selectVoucher(Voucher voucher) {
    selectedVoucher.value = voucher;
    voucherCode.value = voucher.code;
    discountAmount.value = voucher.value;
  }

  bool isSelected(Voucher voucher) {
    return selectedVoucher.value?.id == voucher.id;
  }

  void applyVoucher() {
    // Simulate a network request
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }
}
