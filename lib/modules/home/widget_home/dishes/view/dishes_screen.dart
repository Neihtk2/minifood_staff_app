import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/core/constants/app_string.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/controller/dishes_controller.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/item_widget_dishes/item_widget_home.dart';

class DishesScreen extends StatefulWidget {
  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen>
    with SingleTickerProviderStateMixin {
  final DishesController controller = Get.find<DishesController>();
  late TabController _tabController;
  final List<String> _tabNames = [
    AppStrings.imagedish1,
    AppStrings.imagedish2,
    AppStrings.imagedish3,
  ];
  late List<CustomDataListView> _dataRenderers;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabNames.length, vsync: this);
    _dataRenderers = [
      CustomDataListView(dishes: controller.mainDishes),
      CustomDataListView(dishes: controller.beverageDishes),
      CustomDataListView(dishes: controller.dessertDishes),
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
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(RouterName.DISHEDADD);
            },
            child: Text("Thêm sản phẩm"),
            style: ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: Colors.blue,
                  width: 1.0,
                ), // Màu và độ dày viền
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Bo góc
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs:
                  _tabNames
                      .map((name) => Tab(icon: Image.asset(name)))
                      .toList(),
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_tabNames.length, (index) {
                  return CustomDataListView(
                    dishes: _dataRenderers[index].dishes,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
