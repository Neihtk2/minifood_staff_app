import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/voucher_model.dart';
import 'package:minifood_admin/modules/views/vouchers/voucher_controller.dart';

class VoucherItem extends StatelessWidget {
  final Voucher voucher;
  const VoucherItem({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoucherController>();

    return Obx(() {
      final isSelected = controller.isSelected(voucher);
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              voucher.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            ),
          ),
          title: Text(
            voucher.code,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Giảm ${voucher.formattedValue}₫ cho đơn từ ${voucher.formattedMinOrderValue}₫\nHiệu lực: ${voucher.validity}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: ElevatedButton(
            onPressed: () => controller.selectVoucher(voucher),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.green : null,
            ),
            child: Text(isSelected ? 'Đã chọn' : 'Áp dụng'),
          ),
        ),
      );
    });
  }
}
