import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/profile/edit_profile.dart';
import 'package:minifood_staff/modules/views/profile/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key) {}
  @override
  Widget build(BuildContext context) {
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
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 40),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
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
