import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/modules/views/cart/cart_controller.dart';
import 'package:minifood_admin/modules/views/home/controller/dishes_controller.dart';

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
    final CartController cartController = Get.find();
    final quantity = 1.obs;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) {
                    quantity.value--;
                  } else {
                    Get.snackbar(
                      "Thông báo",
                      "Số lượng không thể nhỏ hơn 1",
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.remove, color: Colors.grey, size: 16),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // 🔥 Tắt padding
                ),
                constraints: BoxConstraints(),
              ),
              const SizedBox(width: 10),
              Obx(
                () => Text(
                  '${quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  quantity.value++;
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Color(0xFF4795DE),
                  size: 32,
                ),

                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // 🔥 Tắt padding
                ),
                constraints: BoxConstraints(),
              ),
            ],
          ),
          // Spacer(),
          // Số lượng và nút thêm
          Obx(() {
            return InkWell(
              onTap:
                  cartController.isLoading.value
                      ? null
                      : () {
                        cartController.addToCart(dish.id, quantity.value);
                        Get.snackbar(
                          "Đã thêm",
                          "${dish.name} x${quantity.value} đã thêm vào giỏ",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color.fromARGB(255, 1, 46, 2),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Thêm", style: TextStyle(color: Colors.white)),
                    Text(
                      "${dish.price * quantity.value}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
