import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/orders/item_widget/order_item_widget.dart';
import 'package:minifood_staff/modules/views/orders/order_controller.dart';

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
      appBar: AppBar(),
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
