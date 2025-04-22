import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/modules/views/cart/cart_screen.dart';
import 'package:minifood_admin/modules/views/home/controller/dishes_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DishesController dishesController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final RxList<DishedModel> filteredDishes = <DishedModel>[].obs;
  final RxList<String> searchHistory = <String>[].obs;
  final List<String> popularSearches = ['Trà sữa', 'Pizza', 'Cơm gà', 'Bún bò'];
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
        if (_searchController.text.isNotEmpty) {
          _searchDishes(_searchController.text);
        } else {
          filteredDishes.clear();
        }
      });
    });
  }

  void _searchDishes(String query) {
    final results =
        dishesController.allDishes.where((dish) {
          final nameLower = dish.name.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();

    filteredDishes.value = results;
  }

  void _submitSearch(String query) {
    if (query.isEmpty) return;

    searchHistory.remove(query);
    searchHistory.insert(0, query);
    if (searchHistory.length > 10) searchHistory.removeLast();

    _searchDishes(query);
    Get.to(
      () => SearchResultsScreen(
        searchQuery: query,
        results: filteredDishes.toList(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm món ăn...',
              prefixIcon: Icon(Icons.search),
              suffixIcon:
                  _showClearButton
                      ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                      : null,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: _submitSearch,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => CartScreen()),
          ),
        ],
      ),
      body:
          _searchController.text.isEmpty
              ? _buildSearchHistory()
              : Obx(() => _buildSearchResults()),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: filteredDishes.length,
      itemBuilder: (_, index) {
        final dish = filteredDishes[index];
        return ListTile(
          leading: Icon(Icons.fastfood),
          title: Text(dish.name),
          // subtitle: Text(dish.categoryName ?? ''),
          onTap: () => _submitSearch(dish.name),
        );
      },
    );
  }

  Widget _buildSearchHistory() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lịch sử tìm kiếm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (searchHistory.isNotEmpty)
              GestureDetector(
                onTap: () => searchHistory.clear(),
                child: Icon(Icons.delete_outline, size: 20, color: Colors.grey),
              ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              searchHistory
                  .map(
                    (term) => ActionChip(
                      label: Text(term),
                      onPressed: () => _submitSearch(term),
                    ),
                  )
                  .toList(),
        ),
        Divider(height: 32),
        Text(
          'Xu hướng tìm kiếm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...popularSearches.map(
          (term) => ListTile(
            leading: Icon(Icons.trending_up),
            title: Text(term),
            onTap: () => _submitSearch(term),
          ),
        ),
      ],
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final List<DishedModel> results;

  const SearchResultsScreen({required this.searchQuery, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả cho: "$searchQuery"'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => CartScreen()),
          ),
        ],
      ),
      body:
          results.isEmpty
              ? Center(child: Text('Không tìm thấy món ăn nào.'))
              : ListView.builder(
                itemCount: results.length,
                itemBuilder: (_, index) {
                  final dish = results[index];
                  return ListTile(
                    title: Text(dish.name),
                    // subtitle: Text(dish.categoryName ?? ''),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(dish.image),
                    ),
                    onTap: () {
                      // TODO: Xử lý khi chọn món ăn từ kết quả tìm kiếm
                    },
                  );
                },
              ),
    );
  }
}
