import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/modules/home/widget_home/orders/controller/orders_controller.dart';
import 'package:minifood_admin/modules/home/widget_home/orders/item_widget/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final OrdersController controller = Get.find<OrdersController>();
  late TabController _tabController;
  final List<String> _tabNames = [
    "PENDING",
    "PROCESSING",
    "DELIVERING",
    "COMPLETED",
    "CANCELLED",
  ];
  late List<OrdersListView> _dataRenderers;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabNames.length, vsync: this);
    _dataRenderers = [
      OrdersListView(orders: controller.pending),
      OrdersListView(orders: controller.processing),
      OrdersListView(orders: controller.delivering),
      OrdersListView(orders: controller.completed),
      OrdersListView(orders: controller.cancelled),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Pannel'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Get.toNamed(RouterName.DISHEDADD);
        //     },
        //     icon: Icon(Icons.person_add, size: 30, color: Colors.blue),
        //     style: ButtonStyle(
        //       side: MaterialStateProperty.all<BorderSide>(
        //         BorderSide(
        //           color: Colors.blue,
        //           width: 1.0,
        //         ), // Màu và độ dày viền
        //       ),
        //       shape: MaterialStateProperty.all<OutlinedBorder>(
        //         RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8.0), // Bo góc
        //         ),
        //       ),
        //     ),
        //   ),
        //   SizedBox(width: 10),
        // ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: _tabNames.map((name) => Tab(text: name)).toList(),
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_tabNames.length, (index) {
                  return OrdersListView(orders: _dataRenderers[index].orders);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
