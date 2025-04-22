import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_admin/modules/views/home/view/items_widget/drawer_menu.dart';
import 'package:minifood_admin/modules/views/home/view/items_widget/toy_item.dart';

import 'package:minifood_admin/modules/views/home/view/items_widget/toylist.dart';
import 'package:minifood_admin/modules/views/search/search_screen.dart';
import 'package:minifood_admin/modules/views/toys/toys_detail.dart';

class HomeItem extends StatelessWidget {
  HomeItem({super.key});
  @override
  Widget build(BuildContext context) {
    DishesController dishesController = Get.find();
    // List<DishedModel> dishes = dishesController.allDishes;
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        final dishes = dishesController.allDishes;

        if (dishesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (dishes.isEmpty) {
          return const Center(child: Text("Không có món ăn nào."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 10),
              // _buildCategoryIcons(),
              // const SizedBox(height: 10),
              _buildSection(
                "Món ăn phổ biến",
                _buildHorizontalList(dishes),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PopularToysScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildSection("Món mới", _buildVerticalList(dishes), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewToysScreen()),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FA),
      elevation: 0,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: Colors.red, size: 18),
          SizedBox(width: 4),
          Text(
            "Mini Food",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      centerTitle: true,

      actions: [
        GestureDetector(
          onTap: () {
            // Get.to(CartScreen());
            Get.toNamed(RouterName.CART);
          },
          child: Stack(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 26,
                  color: Colors.black,
                ),
              ),
              Positioned(top: 5, right: 5, child: _NotificationDot()),
            ],
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.to(() => SearchScreen()), // Điều hướng sang màn tìm kiếm
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14), // Thêm padding
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              "Tìm món ăn",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    final icons = [
      Icons.toys_rounded,
      Icons.abc,
      Icons.access_alarm,
      Icons.toys,
      Icons.toys_sharp,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: icons.map((icon) => _CircleIcon(icon: icon)).toList(),
    );
  }

  Widget _buildSection(String title, Widget content, VoidCallback onSeeAll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                "See all",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        content,
      ],
    );
  }

  Widget _buildHorizontalList(List<DishedModel> dishes) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => ToyDetailScreen());
            },
            child: DishedCard(dish: dishes[index]),
          );
        },
      ),
    );
  }

  Widget _buildVerticalList(List<DishedModel> dishes) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dishes.length,
      itemBuilder: (context, index) => ToyCard(product: dishes[index]),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  const _CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(icon, size: 26, color: Colors.black),
    );
  }
}

class _NotificationDot extends StatelessWidget {
  const _NotificationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}

// =======================
// Tạo màn hình mới
// =======================
class PopularToysScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Popular Toys")),
      body: const Center(child: Text("Danh sách Popular Toys ở đây")),
    );
  }
}

class NewToysScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Toys")),
      body: const Center(child: Text("Danh sách New Toys ở đây")),
    );
  }
}
