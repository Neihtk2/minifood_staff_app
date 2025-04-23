import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController cartController = Get.find();
  int get subtotal => cartController.filteredCartItem.fold(
    0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () {
            Get.back();
          },
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        title: Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (!cartController.isLoading.value &&
            cartController.filteredCartItem.isEmpty) {
          return Center(child: Text('Không có sản phẩm nào'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.filteredCartItem.length,
                itemBuilder: (context, index) {
                  final item = cartController.filteredCartItem[index];
                  return CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQuantity) {
                      setState(() {
                        item.quantity = newQuantity;
                        cartController.updateCartItem(item.id, newQuantity);
                      });
                    },
                    onRemove: () {
                      setState(() {
                        cartController.filteredCartItem.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            Container(
              height: 70.h,
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      RouterName.CHECKOUT,
                      arguments: {'subtotal': subtotal},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4795DE),
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Tiến hành thanh toán',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final DishedModel item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      height: 100.h,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Image.network(item.image, fit: BoxFit.cover),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  currency.format(item.quantity * item.price),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (item.quantity > 1) {
                          onQuantityChanged(item.quantity - 1);
                        }
                      },
                      icon: Icon(Icons.remove, color: Colors.grey, size: 16.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    IconButton(
                      onPressed: () {
                        onQuantityChanged(item.quantity + 1);
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Color(0xFF4795DE),
                        size: 32.sp,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 24.sp,
                ),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onRemove,
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ],
      ),
    );
  }
}
