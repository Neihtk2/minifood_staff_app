import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/view/dishes_screen.dart';
import 'package:minifood_admin/modules/home/widget_home/orders/controller/orders_controller.dart';
import 'package:minifood_admin/modules/home/widget_home/orders/view/orders_screen.dart';
import 'package:minifood_admin/modules/home/widget_home/users/controller/users_controller.dart';
import 'package:minifood_admin/modules/home/widget_home/users/view/user_screen.dart';

// Main Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const AnalyticsScreen(),
    DishesScreen(),
    GetBuilder<OrdersController>(
      init: OrdersController(),
      builder: (controller) => OrdersScreen(),
    ),
    GetBuilder<UsersController>(
      init: UsersController(),
      builder: (controller) => UsersScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected:
                (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Thống kê'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fastfood),
                label: Text('Sản phẩm'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart),
                label: Text('Đơn hàng'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Người dùng'),
              ),
            ],
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey.shade300)),
              ),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

// Sample Screens
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Màn hình Quản lý Sản phẩm'));
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Màn hình Thống kê'));
  }
}
