import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/user_model.dart';
import 'package:minifood_admin/modules/home/widget_home/dishes/controller/dishes_controller.dart';

class DataUsersListView extends StatelessWidget {
  final List<UserModel> users;
  const DataUsersListView({Key? key, required this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DishesController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (users.isEmpty) {
        return Center(
          child: Text(
            'Không có dữ liệu.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: users.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final user = users[index];
          return _itemwidgetusers(user);
        },
      );
    });
  }

  Widget _itemwidgetusers(UserModel user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Cắt nội dung vượt quá bo góc
      child: InkWell(
        // Hiệu ứng nhấn
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              "https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg",
              height: 150,
              width: 150,
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
            Expanded(
              child: SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sản phẩm
                      Text(
                        user.email,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      // Đánh giá sao
                      // Giá và nút mua
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "id: ${user.id.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, size: 20),
                            onPressed: () => _confirmDelete(user.id.toString()),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
