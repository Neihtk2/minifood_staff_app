// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:minifood_staff/modules/views/checkout/item_widget/checkout_form.dart';
import 'package:minifood_staff/modules/views/checkout/item_widget/order_summary.dart';
import 'package:minifood_staff/modules/views/orders/order_controller.dart';
import 'package:minifood_staff/modules/views/vouchers/controller/voucher_controller.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  VoucherController voucherController = Get.find();
  final RxString paymentMethod = 'cod'.obs;
  late KeyboardVisibilityController _keyboardVisibilityController;
  final RxInt total = 0.obs;
  final RxInt delivery = 0.obs;
  final RxString voucherCode = ''.obs;

  bool _isKeyboardVisible = false;
  @override
  void initState() {
    super.initState();
    ever(voucherController.discountAmount, (discount) {
      delivery.value = discount;
      _calculateTotal();
    });
    ever(voucherController.voucherCode, (code) {
      voucherCode.value = code;
      print('Voucher code nèeeeeee: $code');
    });
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = Get.arguments as Map<String, dynamic>;
    _calculateTotal(subtotal: arguments['subtotal']);
  }

  void _calculateTotal({int? subtotal}) {
    final currentSubtotal = subtotal ?? total.value + delivery.value;
    total.value = currentSubtotal - delivery.value;
  }

  @override
  Widget build(BuildContext context) {
    OrdersController ordersController = Get.find();

    final arguments = Get.arguments as Map<String, dynamic>;
    int subtotal = arguments['subtotal'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        title: const Text(
          'Về giỏ hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CheckoutForm(
              nameController: nameController,
              phoneController: phoneController,
              paymentMethod: paymentMethod,

              currentOrderTotal: subtotal,
            ),
          ),
          if (!_isKeyboardVisible)
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() {
                    _calculateTotal(subtotal: subtotal);
                    return OrderSummary(
                      subtotal: subtotal,

                      total: total.value,
                      delivery: delivery.value,
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed:
                            ordersController.isLoading.value
                                ? null
                                : () async {
                                  if (phoneController.text.isEmpty) {
                                    Get.snackbar(
                                      'Thông báo',
                                      'Vui lòng nhập đầy đủ thông tin',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    await ordersController.createOrder(
                                      nameController.text,
                                      phoneController.text,

                                      paymentMethod.value,
                                      total.value,
                                      voucherCode.value,
                                    );

                                    Get.back();
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4795DE),
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child:
                            ordersController.isLoading.value
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                  'Thanh Toán',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                      );
                    }),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
