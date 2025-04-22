// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/data/models/orders_model.dart';
import 'package:minifood_admin/modules/views/order/order_controller.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    OrdersController ordersController = Get.find<OrdersController>();
    List<OrdersModel> orders = ordersController.orders;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return orders.isEmpty
            ? Center(child: Text("Không có đơn hàng nào"))
            : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderItem(orders[index]);
              },
            );
      }),
    );
  }

  Widget _buildOrderItem(OrdersModel order) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên cửa hàng + trạng thái đơn hàng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.store),
                  SizedBox(width: 8),
                  Text(
                    order.id,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                order.status,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Hình ảnh + Chi tiết sản phẩm
          ListView.builder(
            itemCount: order.items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return OrderItemWidget(item: order.items[index]);
            },
          ),
          Divider(thickness: 1, height: 30),

          // Tổng tiền
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Total: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "\$${order.total}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(thickness: 1, height: 30),

          // Lưu ý
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Please only click "Order Received" once the order has been delivered to you and there are no problems with the product',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10),

              // Nút "Order Received"
              ElevatedButton(
                onPressed: () {
                  // Handle order received logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor:
                      Colors.red.shade200, // Làm mờ khi disable
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Order Received",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final DishedModel item;
  const OrderItemWidget({Key? key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 100,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hình ảnh món ăn
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(item.image, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          // Chi tiết món ăn
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'x${item.quantity}',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${item.quantity * item.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
