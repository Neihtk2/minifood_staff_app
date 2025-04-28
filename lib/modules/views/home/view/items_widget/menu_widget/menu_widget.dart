import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/core/constants/app_string.dart';

import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/menu_widget_item.dart';

class MenuWidget extends StatefulWidget {
  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget>
    with SingleTickerProviderStateMixin {
  final DishesController controller = Get.find();

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
      appBar: AppBar(),
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
