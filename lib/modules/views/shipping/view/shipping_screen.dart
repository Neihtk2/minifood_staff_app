import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:minifood_staff/modules/views/shipping/controller/shipping_controller.dart';
import 'package:minifood_staff/modules/views/shipping/view/shipping_item/shipping_detail.dart';

class ShippingScreen extends StatefulWidget {
  @override
  State<ShippingScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<ShippingScreen>
    with SingleTickerProviderStateMixin {
  late ShippingController controller;
  late TabController _tabController;
  final List<String> _tabNames = ["Đơn cần giao", "Đơn đã nhận"];
  late List<ShippingDetail> _dataRenderers;
  @override
  void initState() {
    super.initState();
    controller = Get.find<ShippingController>();
    _tabController = TabController(length: _tabNames.length, vsync: this);
    _dataRenderers = [
      ShippingDetail(orders: controller.getOrdersDelivery),
      ShippingDetail(orders: controller.getAcceptedDelivery),
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
                  return ShippingDetail(orders: _dataRenderers[index].orders);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
