// lib/presentation/views/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/core/constants/app_string.dart';
import 'package:minifood_staff/modules/auth/controller/auth_controller.dart';

class ForgotpassScreen extends GetView<AuthController> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Container(
        // color: Colors.white70,
        margin: EdgeInsets.symmetric(horizontal: 35.r),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              Text(
                'Recovery Password',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.Roboto,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Please Enter Your Email Address To Recieve a Verification Code",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                  fontFamily: AppStrings.Roboto,
                ),
              ),
              SizedBox(height: 40.h),
              Row(
                children: [
                  Text(
                    "Email Address",
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

              SizedBox(height: 10.h),
              _buildEmailField(),

              SizedBox(height: 30.h),
              _buildForgotButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        filled: true,
        fillColor: Colors.grey[100],
        hintText: "Email Addsress",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildForgotButton() {
    return Obx(
      () => InkWell(
        onTap:
            controller.isLoading.value
                ? null
                : () => controller.forgotpass(_emailController.text.trim()),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Colors.blueAccent,
          ),
          height: 70.h,
          width: double.infinity,

          child:
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : Center(
                    child: Text(
                      'Continue',
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
