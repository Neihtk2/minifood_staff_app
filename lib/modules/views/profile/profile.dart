import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/core/routes/app_routes.dart';
import 'package:minifood_staff/modules/views/profile/edit_profile.dart';
import 'package:minifood_staff/modules/views/profile/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key) {}
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final ProfileController prf = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Get.to(() => EditProfile(), arguments: prf.profile.value);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (prf.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = prf.profile.value;
        if (user == null) {
          return Center(
            child: Text(
              prf.error.isNotEmpty
                  ? prf.error.value
                  : "Không thể tải thông tin người dùng!",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        // Debug API

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Ảnh đại diện
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user.image != null && user.image!.isNotEmpty
                          ? NetworkImage(user.image!)
                          : const NetworkImage(
                            "https://cdn.kona-blue.com/upload/kona-blue_com/post/images/2024/09/19/467/avatar-anime-nam-10.jpg",
                          ),
                ),
              ),
              const SizedBox(height: 10),

              // Tên người dùng
              Text(
                user.name != null ? user.name! : "Chưa có tên",

                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Các trường thông tin người dùng
              _buildProfileField("Full Name", user.name ?? "Chưa có tên"),

              _buildProfileField(
                "Email Address",
                user.email ?? "Chưa có email",
              ),
              _buildProfileField("SĐT", user.phone ?? "Chưa có SĐT"),
              _buildProfileField("Địa Chỉ", user.address ?? "Chưa có tên"),

              box.read(StorageConstants.role) == 'shipper'
                  ? Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await box.remove(StorageConstants.accessToken);
                          Get.offAllNamed(RouterName.LOGIN);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          disabledBackgroundColor:
                              Colors.red.shade200, // Làm mờ khi disable
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Đăng Xuất",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          obscureText: label == "Password",
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
