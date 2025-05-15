import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';

import 'package:minifood_staff/data/models/voucher_model.dart';
import 'package:minifood_staff/data/sources/remote/api_service.dart';

abstract class VouchersReponsitory {
  Future<List<Voucher>> getAllVouchers();
  Future<void> applyVoucher(String code);
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
    if (token == null) throw Exception("Vui lòng đăng nhập");

    try {
      final response = await api.dio.get(
        Endpoints.vouchers,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return handleVoucherResponse(response);
    } on DioException catch (e) {
      throw handleDioError(e, "Lỗi tải danh sách voucher");
    } catch (e) {
      throw Exception("Lỗi không xác định: ${e.toString()}");
    }
  }

  @override
  Future<void> applyVoucher(String code) async {
    if (code.isEmpty) {
      throw Exception("Vui lòng nhập mã giảm giá");
    }

    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.post(
        "${Endpoints.vouchers}/apply",
        data: {"voucherCode": code.toUpperCase()},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? "Áp dụng voucher thất bại");
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['message'] ?? "Lỗi kết nối";
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception("Lỗi không xác định: ${e.toString()}");
    }
  }
}

List<Voucher> handleVoucherResponse(Response response) {
  if (response.statusCode != 200) {
    throw Exception("Lỗi server: ${response.statusCode}");
  }

  try {
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> jsonList = data['data'] ?? [];
    return jsonList.map((json) => Voucher.fromJson(json)).toList();
  } catch (e) {
    throw FormatException('Định dạng dữ liệu voucher không hợp lệ');
  }
}

Exception handleDioError(DioException e, String defaultMessage) {
  final errorMsg =
      e.response?.data?['message']?.toString() ?? e.message ?? defaultMessage;
  return Exception(errorMsg);
}
