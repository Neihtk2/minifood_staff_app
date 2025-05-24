import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/data/models/orders_model.dart';
import 'package:minifood_staff/modules/views/orders/order_controller.dart';
import 'package:minifood_staff/modules/views/orders/order_detail.dart';

class OrdersListView extends StatelessWidget {
  final List<OrdersModel> orders;
  const OrdersListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    OrdersController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (orders.isEmpty) {
        return const Center(
          child: Text(
            'Không có đơn hàng nào.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await controller.refreshOrders();
        },
        child: ListView.builder(
          padding: EdgeInsets.all(8.0.r),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _orderItemWidget(context, order, controller);
          },
        ),
      );
    });
  }

  Widget _orderItemWidget(
    BuildContext context,
    OrdersModel order,
    OrdersController controller,
  ) {
    return InkWell(
      onTap: () {
        Get.to(OrderDetailScreen(order: order));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mã đơn hàng & Chuyển trạng thái
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      "Mã đơn: ${order.id}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: 16.sp,
                      ),
                    ),
                  ),
                  _buildStatusDropdown(order, controller),
                ],
              ),
              SizedBox(height: 8.h),

              // Thông tin khách hàng
              Text("Khách hàng: ${order.customerName}"),
              Text("SĐT: ${order.phone}"),
              Text("Địa chỉ: ${order.deliveryAddress}"),
              SizedBox(height: 8.h),

              // Phương thức thanh toán & Tổng tiền
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Thanh toán: ${order.paymentMethod}"),
                  Text(
                    "Tổng: ${order.total}đ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(OrdersModel order, OrdersController controller) {
    RxString orderStatus = order.status.obs;
    List<String> statuses = [
      "pending",
      "processing",
      "delivering",
      "completed",
      "cancelled",
      "rejected",
    ];

    return Obx(
      () => DropdownButton<String>(
        value: orderStatus.value,
        onChanged: (String? newStatus) {
          if (newStatus != null && newStatus != orderStatus.value) {
            orderStatus.value = newStatus; // Cập nhật giá trị trạng thái
            controller.updateOrders(newStatus, order.id);
          }
        },
        items:
            statuses.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status.toUpperCase()),
              );
            }).toList(),
      ),
    );
  }
}
