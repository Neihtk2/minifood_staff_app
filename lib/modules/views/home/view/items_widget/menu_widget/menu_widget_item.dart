import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minifood_staff/data/models/dished_model.dart';
import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/dish_view/dished_detail.dart';

class CustomDataListView extends StatelessWidget {
  final List<DishedModel> dishes;
  const CustomDataListView({Key? key, required this.dishes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DishesController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      }

      if (dishes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 60.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'Không có món nào.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: GridView.builder(
          itemCount: dishes.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return _buildDishCard(context, dish);
          },
        ),
      );
    });
  }

  Widget _buildDishCard(BuildContext context, DishedModel dish) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return GestureDetector(
      onTap: () => Get.to(() => DishDetailScreen(dishId: dish.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dish image with overlay gradient
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Hero(
                      tag: 'dish_image_${dish.id}',
                      child: Image.network(
                        dish.image,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Dish details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dish name
                    Text(
                      dish.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    // Dish price
                    Text(
                      currency.format(dish.price),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: Colors.green[700],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Add to cart button
                    ElevatedButton(
                      onPressed:
                          () => Get.to(() => DishDetailScreen(dishId: dish.id)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 36.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            "Thêm vào giỏ",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
