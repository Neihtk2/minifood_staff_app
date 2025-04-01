import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/modules/home/widget_home/users/controller/users_controller.dart';
import 'package:minifood_admin/modules/home/widget_home/users/item_widget/item_widget_users.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {
  final UsersController controller = Get.find<UsersController>();
  late TabController _tabController;
  final List<String> _tabNames = ["ADMIN", "STAFF", "USER"];
  late List<DataUsersListView> _dataRenderers;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabNames.length, vsync: this);
    _dataRenderers = [
      DataUsersListView(users: controller.admin),
      DataUsersListView(users: controller.staff),
      DataUsersListView(users: controller.user),
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
          IconButton(
            onPressed: () {
              Get.toNamed(RouterName.DISHEDADD);
            },
            icon: Icon(Icons.person_add, size: 30.sp, color: Colors.blue),
            style: ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: Colors.blue,
                  width: 1.0.w,
                ), // Màu và độ dày viền
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0.r), // Bo góc
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                  return DataUsersListView(users: _dataRenderers[index].users);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
