import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/core/routes/app_routes.dart';
import 'package:minifood_staff/data/models/dished_model.dart';
import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/drawer_menu.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/dish_view/dishes_item.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/dish_view/dishes_list.dart';
import 'package:minifood_staff/modules/views/search/search_screen.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dishesController = Get.find<DishesController>();

    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (dishesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (dishesController.allDishes.isEmpty) {
          return const Center(child: Text("Không có món ăn nào."));
        }

        return RefreshIndicator(
          onRefresh: dishesController.refreshDishes,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 15),
                _buildSection(
                  "Món ăn phổ biến",
                  _buildHorizontalList(dishesController.topDishes),
                ),
                const SizedBox(height: 15),
                _buildSection(
                  "Món mới",
                  _buildVerticalList(dishesController.newDishes),
                ),
              ],
            ),
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
          onTap: () => Get.toNamed(RouterName.CART),
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
      onTap: () => Get.to(() => SearchScreen()),
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
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: const Row(
          children: [
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

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          return Padding(
            padding: const EdgeInsets.only(right: 16),
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
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ToyCard(product: dishes[index]),
        );
      },
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
