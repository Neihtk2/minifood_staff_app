import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:minifood_admin/modules/views/home/view/items_widget/home_iteam.dart';
import 'package:minifood_admin/modules/views/home/view/items_widget/menu_widget/menu_widget.dart';
import 'package:minifood_admin/modules/views/profile/profile.dart';
import 'package:minifood_admin/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';
import 'package:minifood_admin/modules/views/profile/profile_controller.dart';
import 'package:minifood_admin/modules/views/vouchers/voucher_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomeItem(), MenuWidget(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: FutureBuilder(
        future: _initializeControllers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            ); // Hiển thị loading khi chưa tải xong
          }
          if (snapshot.hasError) {
            return Center(child: Text('Có lỗi khi khởi tạo controller'));
          }

          return Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            body: _pages[_selectedIndex],
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Color(0xFFF8F9FA)!,
              color: Colors.white,
              buttonBackgroundColor: Colors.blue,
              height: 60,
              animationDuration: Duration(milliseconds: 300),
              index: _selectedIndex,
              items: <Widget>[
                Icon(
                  Icons.home,
                  size: 30,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                ),
                Icon(
                  Icons.restaurant_menu,
                  size: 30,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                ),
                Icon(
                  Icons.person,
                  size: 30,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _initializeControllers() async {
    await Get.putAsync(() async => DishesController());
    await Get.putAsync(() async => ProfileController());
    await Get.putAsync(() async => CartController());
    // await Get.putAsync(() async => VoucherController());
  }
}
