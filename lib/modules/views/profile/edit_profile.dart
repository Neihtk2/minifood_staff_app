import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/data/models/user_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel prf = Get.arguments as UserModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
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
              // Chức năng chỉnh sửa
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Ảnh đại diện
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://cdn.kona-blue.com/upload/kona-blue_com/post/images/2024/09/19/467/avatar-anime-nam-10.jpg",
                    ),
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
              prf.name ?? "Chưa có tên",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Các trường thông tin người dùng
            _buildProfileField("Full Name", prf.name ?? "Chưa có tên"),
            _buildProfileField("Email Address", prf.email ?? "Chưa có email"),
            _buildProfileField("SĐT", prf.phone ?? "Chưa có SĐT"),
            _buildProfileField("Address", prf.address ?? "Chưa có địa chỉ"),

            // Chọn giới tính
            // const SizedBox(height: 10),
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text("Gender", style: TextStyle(fontSize: 14, color: Colors.grey)),
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: RadioListTile(
            //         title: const Text("Male"),
            //         value: "Male",
            //         groupValue: _gender,
            //         onChanged: (value) {
            //           setState(() {
            //             _gender = value.toString();
            //           });
            //         },
            //       ),
            //     ),
            //     Expanded(
            //       child: RadioListTile(
            //         title: const Text("Female"),
            //         value: "Female",
            //         groupValue: _gender,
            //         onChanged: (value) {
            //           setState(() {
            //             _gender = value.toString();
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),

            // Nút Update
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.snackbar(
                    "Success",
                    "Profile updated successfully",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo ô nhập thông tin
  Widget _buildProfileField(
    String label,
    String value, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          obscureText: isPassword,
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
