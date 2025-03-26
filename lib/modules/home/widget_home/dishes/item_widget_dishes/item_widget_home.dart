import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/controller/dishes_controller.dart';

class CustomDataListView extends StatelessWidget {
  final List<DishedModel> dishes;
  const CustomDataListView({Key? key, required this.dishes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DishesController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (dishes.isEmpty) {
        return Center(
          child: Text(
            'Không có dữ liệu.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return ListView.builder(
        itemCount: dishes.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return _itemwidgetdishes(dish);
        },
      );
    });
  }

  Widget _itemwidgetdishes(DishedModel dish) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Cắt nội dung vượt quá bo góc
      child: InkWell(
        // Hiệu ứng nhấn
        borderRadius: BorderRadius.circular(12),
        onTap: () => print(dish.image),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              dish.image,

              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint("Lỗi tải ảnh: $error");
                return Container(
                  color: Colors.grey[200],
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported),
                      Text("Không thể tải ảnh", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
            // Thông tin sản phẩm
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dish.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, size: 20),
                        onPressed: () => print('Thêm vào giỏ hàng'),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Đánh giá sao
                  // Giá và nút mua
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dish.price.toString() + " VNĐ",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),

                      IconButton(
                        icon: Icon(Icons.delete, size: 20),
                        onPressed: () => _confirmDelete(dish.id),
                        padding: EdgeInsets.zero,
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
  }
}

void _confirmDelete(String dishId) {
  DishesController controller = Get.find();
  Get.defaultDialog(
    contentPadding: EdgeInsets.all(8),
    title: "Xác nhận xoá",
    middleText: "Bạn có chắc chắn muốn xoá món ăn này?",
    textCancel: "Hủy",
    textConfirm: "OK",
    confirmTextColor: Colors.white,
    onConfirm: () {
      controller.deleteDished(dishId); // Gọi hàm xoá
      Get.back(); // Đóng hộp thoại
    },
  );
}

// void _confirmDelete(BuildContext context, String dishId) {
//   DishesController controller = Get.find();
//   showDialog(
//     context: context,
//     builder:
//         (context) => AlertDialog(
//           title: Text('Xóa món ăn'),
//           content: Text('Bạn có chắc chắn muốn xóa món ăn này không?'),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(),
//               child: Text('Hủy'),
//             ),
//             TextButton(
//               onPressed: () {
//                 controller.deleteDished(dishId);
//                 Get.back();
//               },
//               child: Text('Xóa', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         ),
//   );
// }
