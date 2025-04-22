import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/api_constants.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/core/utils/error/error_func.dart';
import 'package:minifood_admin/data/models/voucher_model.dart';
import 'package:minifood_admin/data/sources/remote/api_service.dart';

abstract class VouchersReponsitory {
  Future<List<Voucher>> getAllVouchers();
  Future<void> deleteVoucher(String id);
  Future<Response> createVoucher({
    required String code,
    required int value, // Giá trị giảm giá
    required int minOrderValue, // Giá trị đơn hàng tối thiểu
    required DateTime startDate, // Ngày bắt đầu
    required DateTime endDate, // Ngày kết thúc
    int? maxUses, // Số lần sử dụng tối đa (tùy chọn)
    int? maxUsagePerUser, // Số lần sử dụng tối đa mỗi user (tùy chọn)
  });
  Future<Response> updateVoucher(
    String id,
    String? name,
    int? price,
    String? category,
    File? imageFile,
    String token,
  );
}

class VouchersReponsitoryImpl implements VouchersReponsitory {
  final ApiService api = Get.find();
  static final VouchersReponsitoryImpl _instance =
      VouchersReponsitoryImpl._internal();
  VouchersReponsitoryImpl._internal();
  final box = GetStorage();
  static VouchersReponsitoryImpl get instance => _instance;

  @override
  Future<List<Voucher>> getAllVouchers() async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.vouchers,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final orders = _handleResponse(response);
      return orders;
    } on DioException catch (e) {
      handleError(e);
      return [];
    }
  }

  @override
  Future<void> deleteVoucher(String id) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.delete(
        '${Endpoints.vouchers}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }

  @override
  Future<Response> updateVoucher(
    String id,
    String? name,
    int? price,
    String? category,
    File? imageFile,
    String token,
  ) {
    // TODO: implement updateVoucher
    throw UnimplementedError();
  }

  @override
  Future<Response> createVoucher({
    required String code,

    required int value,
    required int minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? maxUses,
    int? maxUsagePerUser,
  }) async {
    final token = box.read(StorageConstants.accessToken);
    Voucher voucher = Voucher(
      code: code,

      value: value,
      minOrderValue: minOrderValue,
      startDate: startDate,
      endDate: endDate,
      maxUses: maxUses,
      maxUsagePerUser: maxUsagePerUser,
    );
    try {
      final response = await api.dio.post(
        Endpoints.vouchers,
        data: voucher.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      if (e.response != null) {
        print("Lỗi từ server: ${e.response}");
        return e.response!;
      } else {
        throw Exception('Lỗi kết nối: ${e.message}');
      }
    }
  }
}

List<Voucher> _handleResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201) return [];
  try {
    final List<dynamic> jsonList = response.data['data'];
    return jsonList.map((json) => Voucher.fromJson(json)).toList();
  } catch (e) {
    throw const FormatException('Invalid user data format');
  }
}
