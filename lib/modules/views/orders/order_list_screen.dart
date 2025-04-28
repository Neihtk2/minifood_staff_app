// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:minifood_staff/core/utils/color_status/color_status.dart';

// import 'package:minifood_staff/data/models/dished_model.dart';
// import 'package:minifood_staff/data/models/orders_model.dart';
// import 'package:minifood_staff/modules/views/orders/order_controller.dart';
// import 'package:minifood_staff/modules/views/orders/order_detail.dart';
// import 'package:minifood_staff/modules/views/orders/order_review.dart';

// class OrderListScreen extends StatelessWidget {

//   const OrderListScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     OrdersController ordersController = Get.find<OrdersController>();
//     List<OrdersModel> orders = ordersController.orders;
//     List<OrdersModel> getOrders = Get.arguments;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "Đơn hàng",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: false,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       backgroundColor: Colors.white,
//       body: Obx(() {
//         return orders.isEmpty
//             ? Center(child: Text("Không có đơn hàng nào"))
//             : ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 return _buildOrderItem(orders[index]);
//               },
//             );
//       }),
//     );
//   }

//   Widget _buildOrderItem(OrdersModel order) {
//     final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
//     return InkWell(
//       onTap: () {
//         Get.to(OrderDetailScreen(order: order));
//       },
//       child: Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               // color: Colors.grey.withOpacity(0.2),
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 5,
//               spreadRadius: 1,
//             ),
//           ],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.store),
//                     SizedBox(width: 8),
//                     Text(
//                       order.id,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//                 Text(
//                   getStatusText(order.status),
//                   style: TextStyle(
//                     color: getStatusColor(order.status),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),

//             ListView.builder(
//               itemCount: order.items.length,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return OrderItemWidget(
//                   item: order.items[index],
//                   orderStatus: order.status,
//                 );
//               },
//             ),
//             Divider(thickness: 1, height: 30),

//             // Tổng tiền
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "Tổng: ",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       '${currency.format(order.total)}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Divider(thickness: 1, height: 30),

//             // Lưu ý
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 order.status == "completed"
//                     ? Expanded(
//                       child: Text(
//                         "Bạn có thể đánh giá các món ăn",
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     )
//                     : SizedBox.shrink(),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     disabledBackgroundColor:
//                         Colors.red.shade200, // Làm mờ khi disable
//                     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     "Huỷ đơn",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrderItemWidget extends StatelessWidget {
//   final DishedModel item;
//   final String orderStatus;
//   const OrderItemWidget({
//     Key? key,
//     required this.item,
//     required this.orderStatus,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
//     return InkWell(
//       onTap:
//           orderStatus == "completed"
//               ? () {
//                 Get.to(ReviewScreen(dished: item));
//               }
//               : null,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         height: 100,
//         width: double.infinity,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.pink.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Image.network(item.image, fit: BoxFit.cover),
//             ),
//             const SizedBox(width: 16),
//             // Chi tiết món ăn
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(left: 8),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           'x${item.quantity}',
//                           style: TextStyle(color: Colors.green, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     ' ${currency.format(item.quantity * item.price)}',

//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
