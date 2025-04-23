import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/api_constants.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/core/utils/error/error_func.dart';
import 'package:minifood_admin/data/models/voucher_model.dart';
import 'package:minifood_admin/data/sources/remote/api_service.dart';

abstract class VouchersReponsitory {
  Future<List<Voucher>> getAllVouchers(int total);
}

class VouchersReponsitoryImpl implements VouchersReponsitory {
  final ApiService api = Get.find();
  static final VouchersReponsitoryImpl _instance =
      VouchersReponsitoryImpl._internal();
  VouchersReponsitoryImpl._internal();
  final box = GetStorage();
  static VouchersReponsitoryImpl get instance => _instance;

  @override
  Future<List<Voucher>> getAllVouchers(int total) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        "${Endpoints.vouchers}?orderTotal=$total",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final orders = _handleResponse(response);
      return orders;
    } on DioException catch (e) {
      handleError(e);
      return [];
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
