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
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Tìm món ăn...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
            onChanged: controller.searchDishes,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              controller.searchDishes('');
              searchController.clear();
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Obx(() {
          return Column(
            children: [
              if (controller.suggestions.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gợi ý tìm kiếm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            controller.suggestions
                                .map(
                                  (suggestion) => ActionChip(
                                    backgroundColor: Colors.grey.shade200,
                                    labelStyle: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                    avatar: const Icon(Icons.search, size: 16),
                                    label: Text(suggestion),
                                    onPressed: () {
                                      searchController.text = suggestion;
                                      controller.searchDishes(suggestion);
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child:
                    controller.filteredDishes.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Không tìm thấy món ăn nào',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                        : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: controller.filteredDishes.length,
                          itemBuilder: (context, index) {
                            final dish = controller.filteredDishes[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => DishDetailScreen(dishId: dish.id));
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        dish.image,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  height: 120,
                                                  color: Colors.grey.shade300,
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dish.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${dish.price} đ',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '${dish.averageRating.toStringAsFixed(1)}/5 (${dish.ratingCount})',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
