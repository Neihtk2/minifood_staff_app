import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/dish_view/dished_detail.dart';
import 'package:minifood_staff/modules/views/search/search_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final SearchDishesController controller = Get.put(SearchDishesController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm món ăn...',
            border: InputBorder.none,
          ),
          onChanged: controller.searchDishes,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.searchDishes('');
              searchController.clear();
            },
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            if (controller.suggestions.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: Colors.grey.shade200,
                child: Wrap(
                  spacing: 8,
                  children:
                      controller.suggestions
                          .map(
                            (suggestion) => ActionChip(
                              label: Text(suggestion),
                              onPressed: () {
                                controller.searchDishes(suggestion);
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredDishes.length,
                itemBuilder: (context, index) {
                  final dish = controller.filteredDishes[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        dish.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.error),
                      ),
                    ),
                    title: Text(dish.name),
                    subtitle: Text('${dish.price} đ'),
                    onTap: () {
                      Get.to(
                        () => DishDetailScreen(dishId: dish.id),
                      ); // Anh tự gắn thêm vào đây
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
