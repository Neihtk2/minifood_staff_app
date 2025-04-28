import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/data/models/dished_model.dart';

import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';
import 'package:minifood_staff/modules/views/home/view/items_widget/menu_widget/dish_view/dished_detail.dart';

class CustomDataListView extends StatelessWidget {
  final List<DishedModel> dishes;
  const CustomDataListView({Key? key, required this.dishes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final CartController cartController = Get.find();
    final DishesController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (dishes.isEmpty) {
        return const Center(
          child: Text(
            'Không có dữ liệu.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: dishes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return _itemWidgetDishes(dish);
          },
        ),
      );
    });
  }

  Widget _itemWidgetDishes(DishedModel dish) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh món ăn
          Expanded(
            child: Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(dish.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Tên món ăn
          Text(
            dish.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Giá
          SizedBox(height: 4.h),
          Text(
            '${dish.price} VNĐ',
            style: TextStyle(color: Colors.grey, fontSize: 24.sp),
          ),
          SizedBox(height: 8.h),

          InkWell(
            onTap: () => Get.to(DishDetailScreen(dishId: dish.id)),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: const Color.fromARGB(255, 1, 46, 2),
              ),

              child: Center(
                child: Text(
                  "Thêm vào giỏ hàng",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
