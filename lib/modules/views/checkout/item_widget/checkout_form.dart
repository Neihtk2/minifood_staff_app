import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/modules/views/checkout/item_widget/voucher_item.dart';
import 'package:minifood_admin/modules/views/vouchers/voucher_controller.dart';

class CheckoutForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController voucherController;
  final RxString paymentMethod;
  final int currentOrderTotal;
  CheckoutForm({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.paymentMethod,
    required this.addressController,
    required this.voucherController,
    required this.currentOrderTotal,
  }) : super(key: key);

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isContactInfoExpanded = true;
  bool _isPaymentMethodExpanded = false;
  @override
  void initState() {
    super.initState();
    // Gọi API khi init
    final controller = Get.find<VoucherController>();
    controller.getVouchersbyTotal(widget.currentOrderTotal);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoucherController>();
    controller.getVouchersbyTotal(widget.currentOrderTotal);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Contact Information
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                ),
                padding: const EdgeInsets.all(4),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: _isContactInfoExpanded,
                    title: const Text(
                      '1. Thông tin liên hệ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isContactInfoExpanded = expanded;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: widget.nameController,
                              decoration: InputDecoration(
                                labelText: 'Tên người nhận',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[300] ?? Colors.grey,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: widget.phoneController,
                              decoration: InputDecoration(
                                labelText: 'Số điện thoại người nhận',
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: widget.addressController,
                              decoration: InputDecoration(
                                labelText: 'Địa chỉ người nhận',
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),

              // 3. Payment Method
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                ),
                padding: const EdgeInsets.all(4),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: _isPaymentMethodExpanded,
                    title: const Text(
                      '2. Phương thức thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isPaymentMethodExpanded = expanded;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    widget.paymentMethod.value = 'cod';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      widget.paymentMethod.value == 'cod'
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                                child: const Text('COD'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    widget.paymentMethod.value = 'cash';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      widget.paymentMethod.value == 'cash'
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                                child: const Text('VNPAY'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              // 3. Voucher
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                ),
                padding: const EdgeInsets.all(4),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: const Text(
                      '3. Mã giảm giá',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Obx(() {
                        final controller = Get.find<VoucherController>();

                        final vouchers = controller.orders;
                        final isLoading = controller.isLoading.value;
                        if (isLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (vouchers.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Không có mã giảm giá nào'),
                          );
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey(vouchers.length),
                            constraints: const BoxConstraints(maxHeight: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: vouchers.length,
                              itemBuilder: (context, index) {
                                final voucher = vouchers[index];
                                return VoucherItem(voucher: voucher);
                              },
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
