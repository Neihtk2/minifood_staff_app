import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minifood_staff/modules/views/cart/cart_controller.dart';
import 'package:minifood_staff/modules/views/home/controller/dishes_controller.dart';

class DishDetailScreen extends StatelessWidget {
  final String dishId;
  DishDetailScreen({super.key, required this.dishId});
  final DishesController controller = Get.find();
  final CartController cartController = Get.find();
  final quantity = 1.obs;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.dish.value == null ||
          controller.dish.value!.id != dishId) {
        controller.fetchDishById(dishId);
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết món ăn")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final dish = controller.dish.value;
        if (dish == null) {
          return Center(child: Text("Không tìm thấy món ăn"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  dish.image,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              Text(
                dish.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                currency.format(dish.price),
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(height: 12),

              Text(
                'Mô tả',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(dish.description),
              SizedBox(height: 12),
              dish.averageRating != 0
                  ? Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        '${dish.averageRating.toStringAsFixed(1)}/5 (${dish.ratingCount} đánh giá)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        'Chưa có đánh giá nào',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
              SizedBox(height: 16),

              // Đánh giá
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đánh giá người dùng:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  if (dish.ratings.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Chưa có đánh giá nào.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...dish.ratings.map(
                      (rating) => ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          rating.star == 0
                              ? "Chưa có đánh giá"
                              : '★ ${rating.star}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          (rating.comment.trim().isEmpty
                                  ? "Chưa có bình luận"
                                  : rating.comment) +
                              "\n" +
                              rating.formattedDate,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 16),

              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // nút trừ
                      IconButton(
                        onPressed: () {
                          if (quantity.value > 1) quantity.value--;
                        },
                        icon: Icon(Icons.remove, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),

                      // số lượng
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${quantity.value}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // nút cộng
                      IconButton(
                        onPressed: () {
                          quantity.value++;
                        },
                        icon: Icon(Icons.add, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
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
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: const Color.fromARGB(255, 1, 46, 2),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Thêm", style: TextStyle(color: Colors.white)),
                        Text(
                          currency.format(dish.price * quantity.value),

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
      }),
    );
  }
}
