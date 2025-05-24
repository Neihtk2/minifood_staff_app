import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/data/models/orders_model.dart';
import 'package:minifood_staff/modules/views/map/map_screen.dart';

import 'package:minifood_staff/modules/views/orders/order_controller.dart';
import 'package:minifood_staff/modules/views/orders/order_detail.dart';
import 'package:minifood_staff/modules/views/shipping/controller/shipping_controller.dart';

class ShippingDetail extends StatelessWidget {
  final List<OrdersModel> orders;
  const ShippingDetail({super.key, required this.orders});
  @override
  Widget build(BuildContext context) {
    ShippingController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (orders.isEmpty) {
        return Center(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshOrders();
            },
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Quan trọng: Cho phép cuộn luôn
              child: Container(
                height:
                    MediaQuery.of(context).size.height *
                    0.8, // Chiếm 80% chiều cao màn hình
                alignment: Alignment.center,
                child: Text(
                  'Không có đơn hàng nào.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await controller.refreshOrders();
        },
        child: ListView.builder(
          // shrinkWrap: true,
          // physics: const AlwaysScrollableScrollPhysics(),
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
    ShippingController controller,
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

              Text("Khách hàng: ${order.customerName}"),
              Text("SĐT: ${order.phone}"),
              Text("Địa chỉ: ${order.deliveryAddress}"),
              SizedBox(height: 8.h),

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
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed:
                      order.shipper.isEmpty
                          ? () {
                            controller.acceptOrderForDelivery(order.id);
                          }
                          : () {
                            Get.to(
                              MapScreen(
                                destinationAddress: order.deliveryAddress,
                              ),
                            );
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
                  child:
                      order.shipper.isEmpty
                          ? Text(
                            "Nhận đơn",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : Text(
                            "Chỉ đường",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(
    OrdersModel order,
    ShippingController controller,
  ) {
    RxString orderStatus = order.status.obs;
    List<String> statuses = ["delivering", "completed", "rejected"];

    return Obx(
      () => DropdownButton<String>(
        value: orderStatus.value,
        onChanged: (String? newStatus) {
          if (newStatus != null && newStatus != orderStatus.value) {
            orderStatus.value = newStatus;
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
