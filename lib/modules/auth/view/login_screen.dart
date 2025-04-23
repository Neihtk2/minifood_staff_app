// lib/presentation/views/auth/login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_admin/core/constants/app_string.dart';
import 'package:minifood_admin/core/routes/app_routes.dart';
import 'package:minifood_admin/modules/auth/controller/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90.h),
              Text(
                'Hello Again!',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.Roboto,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Welcome Back You've Been Missed!",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                  fontFamily: AppStrings.Roboto,
                ),
              ),
              SizedBox(height: 40.h),
              _buildTextField('Email Address', _emailController),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.red, fontSize: 18.sp),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildPasswordField(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Recovery Password',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildLoginButton(),
              SizedBox(height: 140.h),
              RichText(
                text: TextSpan(
                  text: "Don't Have An Account? ",
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: 'Sign Up For Free',
                      style: TextStyle(color: Colors.blue),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(RouterName.REGISTER),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              hint,
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
            Text(" *", style: TextStyle(color: Colors.red, fontSize: 18.sp)),
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextField(
        controller: _passwordController,
        obscureText: controller.isPasswordHidden.value,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 20.w,
          ),
          fillColor: Colors.grey[100],
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordHidden.value
                  ? Icons
                      .visibility_off // Icon khi mật khẩu đang ẩn
                  : Icons.visibility, // Icon khi mật khẩu đang hiện
            ),
            onPressed: () {
              controller.isPasswordHidden.value =
                  !controller.isPasswordHidden.value;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => InkWell(
        onTap:
            controller.isLoading.value
                ? null
                : () => controller.login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Colors.blueAccent,
          ),
          height: 70.h,
          width: double.infinity,
          child:
              controller.isLoading.value
                  ? Center(child: const CircularProgressIndicator())
                  : Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
