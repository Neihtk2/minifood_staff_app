// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'package:minifood_admin/modules/views/cart/cart_screen.dart';
import 'package:minifood_admin/modules/views/order/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // OrdersController ordersController = Get.find();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController voucherController = TextEditingController();
  final RxString paymentMethod = 'cod'.obs;
  late KeyboardVisibilityController _keyboardVisibilityController;
  bool _isKeyboardVisible = false;
  @override
  void initState() {
    super.initState();
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    OrdersController ordersController = Get.find();
    final arguments = Get.arguments as Map<String, dynamic>;
    int subtotal = arguments['subtotal'];
    int shipping = arguments['shipping'];
    int total = arguments['total'];
    int delivery = arguments['delivery'];
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
              addressController: addressController,
              voucherController: voucherController,
            ),
          ),
          if (!_isKeyboardVisible)
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OrderSummary(
                    subtotal: subtotal,
                    shipping: shipping,
                    total: total,
                    delivery: delivery,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed:
                            ordersController.isLoading.value
                                ? null
                                : () async {
                                  if (addressController.text.isEmpty ||
                                      phoneController.text.isEmpty) {
                                    Get.snackbar(
                                      'Thông báo',
                                      'Vui lòng nhập đầy đủ thông tin',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    await ordersController.creatOrder(
                                      nameController.text,
                                      phoneController.text,
                                      addressController.text,
                                      paymentMethod.value,
                                      total,
                                      voucherController.text,
                                    );
                                    Get.back();
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4795DE),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:
                            ordersController.isLoading.value
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                                  'Thanh Toán',
                                  style: TextStyle(
                                    fontSize: 16,
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

class CheckoutForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController voucherController;
  final RxString paymentMethod;
  CheckoutForm({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.paymentMethod,
    required this.addressController,
    required this.voucherController,
  }) : super(key: key);

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isContactInfoExpanded = true;
  bool _isPaymentMethodExpanded = false;

  @override
  Widget build(BuildContext context) {
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
              // 2. Delivery Method
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(10)),
              //     color: Colors.white,
              //     border: Border.all(color: Colors.grey[300] ?? Colors.grey),
              //   ),
              //   padding: const EdgeInsets.all(4),
              //   child: Theme(
              //     data: Theme.of(
              //       context,
              //     ).copyWith(dividerColor: Colors.transparent),
              //     child: ExpansionTile(
              //       initiallyExpanded: _isDeliveryMethodExpanded,
              //       title: const Text(
              //         '2. Phương thức giao hàng',
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       onExpansionChanged: (expanded) {
              //         setState(() {
              //           _isDeliveryMethodExpanded = expanded;
              //         });
              //       },
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 16,
              //             vertical: 8,
              //           ),
              //           child: Wrap(
              //             spacing: 8,
              //             children: [
              //               ChoiceChip(
              //                 label: const Text('SAME_DAY'),
              //                 selected: _deliveryMethod == 'SAME_DAY',
              //                 onSelected: (bool selected) {
              //                   setState(() {
              //                     _deliveryMethod = 'SAME_DAY';
              //                   });
              //                 },
              //               ),
              //               ChoiceChip(
              //                 label: const Text('EXPRESS'),
              //                 selected: _deliveryMethod == 'EXPRESS',
              //                 onSelected: (bool selected) {
              //                   setState(() {
              //                     _deliveryMethod = 'EXPRESS';
              //                   });
              //                 },
              //               ),
              //               ChoiceChip(
              //                 label: const Text('NORMAL'),
              //                 selected: _deliveryMethod == 'NORMAL',
              //                 onSelected: (bool selected) {
              //                   setState(() {
              //                     _deliveryMethod = 'NORMAL';
              //                   });
              //                 },
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
