import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/data/models/voucher_model.dart';
import 'package:minifood_staff/data/repositories/vouchers_reponsitory.dart';

class VoucherController extends GetxController {
  final VouchersReponsitoryImpl repo = VouchersReponsitoryImpl.instance;
  final RxList<Voucher> orders = <Voucher>[].obs;
  final RxList<Voucher> vouchers = <Voucher>[].obs;
  final RxInt orderTotal = 0.obs;
  final selectedVoucher = Rxn<Voucher>();
  final voucherCode = ''.obs;
  final discountAmount = 0.obs;
  final isLoading = false.obs;
  @override
  onInit() {
    super.onInit();
    getVouchers();
  }

  Future<void> getVouchersbyTotal(int total) async {
    try {
      isLoading.value = true;
      final vouchers = await repo.getAllVouchers();
      orderTotal.value = total;
      final currentTotal = total;
      for (var v in vouchers) {
        v.isValid = currentTotal >= v.minOrderValue;
      }
      orders.assignAll(vouchers);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getVouchers() async {
    try {
      isLoading.value = true;
      vouchers.value = await repo.getAllVouchers();
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

  Future<void> applyVoucher(String code) async {
    try {
      await repo.applyVoucher(code);
    } catch (e) {
      Get.snackbar("Lỗi", e.toString(), backgroundColor: Colors.red);
    }
  }
}
