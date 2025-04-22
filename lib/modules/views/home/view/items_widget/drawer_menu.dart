import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/modules/views/profile/profile_controller.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController prf = Get.find();
    return Drawer(
      child: Container(
        color: const Color(0xFF1D2630), // Màu nền tối
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần Header (Ảnh đại diện + Tên)
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1D2630)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://cdn.kona-blue.com/upload/kona-blue_com/post/images/2024/09/19/467/avatar-anime-nam-10.jpg',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Lời chào
                  const Text(
                    "Hey, 👋",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  // Tên người dùng
                  Text(
                    prf.profile.value.name ?? "User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Danh sách menu
            // _buildDrawerItem(Icons.person_outline, "Profile"),
            // _buildDrawerItem(Icons.home_outlined, "Home Page"),
            _buildDrawerItem(Icons.card_giftcard_outlined, "Mã Giảm Giá"),
            _buildDrawerItem(Icons.local_shipping_outlined, "Đơn Hàng"),

            // Dòng kẻ ngăn cách
            const Divider(color: Colors.white54, thickness: 0.5),

            // Nút Sign Out
            _buildDrawerItem(Icons.logout, "Sign Out"),
          ],
        ),
      ),
    );
  }

  // Widget tạo mục menu
  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        // Điều hướng đến trang tương ứng
        if (title == "Sign Out") {
          Get.offAllNamed(RouterName.LOGIN);
        } else if (title == "Đơn Hàng") {
          Get.toNamed(RouterName.ORDERS);
        } else if (title == "Mã Giảm Giá") {
          Get.toNamed(RouterName.SPLASH);
        }
        // else if (title == "Home Page") {
        //   Get.toNamed(Routes.HOME);
        // } else if (title == "Profile") {
        //   Get.toNamed(Routes.PROFILE);
        // }
      },
    );
  }
}
