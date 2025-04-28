import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:minifood_staff/data/models/voucher_model.dart';
import 'package:minifood_staff/modules/views/vouchers/controller/voucher_controller.dart';

class VouchersListView extends StatelessWidget {
  const VouchersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoucherController>();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerList();
          }

          if (controller.vouchers.isEmpty) {
            return const Center(
              child: Text(
                'Không có dữ liệu.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12.w),
            itemCount: controller.vouchers.length,
            itemBuilder: (context, index) {
              final voucher = controller.vouchers[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _itemVoucherCard(voucher),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _itemVoucherCard(Voucher voucher) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                voucher.image,
                height: 100.h,
                width: 100.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 100.h,
                    width: 100.w,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 28.sp),
                        Text(
                          "Không thể tải ảnh",
                          style: TextStyle(fontSize: 12.sp),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.code,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Giảm: ${voucher.formattedValue} VNĐ",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    Text(
                      "Số lượng: ${voucher.maxUses}",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    Text(
                      "Bắt đầu: ${voucher.formattedStartDate}",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    Text(
                      "Kết thúc: ${voucher.formattedEndDate}",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    Text(
                      "Đơn tối thiểu: ${voucher.formattedMinOrderValue} VNĐ",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(12.w),
      itemCount: 6, // số lượng item giả
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 100.h, width: 100.w, color: Colors.white),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16.h,
                            width: 150.w,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 14.h,
                            width: 100.w,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 14.h,
                            width: 120.w,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 14.h,
                            width: 90.w,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
