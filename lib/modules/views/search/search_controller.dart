import 'package:get/get.dart';
import 'package:diacritic/diacritic.dart';
import 'package:minifood_staff/data/models/dished_model.dart';
import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';

class SearchDishesController extends GetxController {
  final DishesController dishesController = Get.find<DishesController>();

  final RxList<DishedModel> filteredDishes = <DishedModel>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Lúc init search screen thì lấy hết danh sách món
    filteredDishes.assignAll(dishesController.allDishes);
  }

  void searchDishes(String query) {
    searchQuery.value = query;
    final normalizedQuery = removeDiacritics(query.toLowerCase().trim());

    if (normalizedQuery.isEmpty) {
      filteredDishes.assignAll(dishesController.allDishes);
      suggestions.clear();
      return;
    }

    final results =
        dishesController.allDishes.where((dish) {
          final name = removeDiacritics(dish.name.toLowerCase());
          final category = removeDiacritics((dish.category).toLowerCase());

          return name.contains(normalizedQuery) ||
              category.contains(normalizedQuery);
        }).toList();

    filteredDishes.assignAll(results);

    final sugg =
        dishesController.allDishes
            .where(
              (dish) => removeDiacritics(
                dish.name.toLowerCase(),
              ).startsWith(normalizedQuery),
            )
            .map((dish) => dish.name)
            .toSet()
            .toList();
    suggestions.assignAll(sugg);
  }
}
