import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/core/utils/error/error_func.dart';

import 'package:minifood_staff/data/models/dished_model.dart';

import 'package:minifood_staff/data/sources/remote/api_service.dart';

abstract class CartReponsitory {
  Future<List<DishedModel>> getCart();
  Future<void> updateStatus(String? status, String id);
  Future<void> addToCart(String id, int quantity);
  Future<void> removeFromCart(String id);
  // Future<void> clearCart();
  Future<void> updateCartItem(String id, int quantity);
}

class CartRepositoryImpl implements CartReponsitory {
  final ApiService api = Get.find();
  static final CartRepositoryImpl _instance = CartRepositoryImpl._internal();
  CartRepositoryImpl._internal();
  final box = GetStorage();
  static CartRepositoryImpl get instance => _instance;
  @override
  Future<List<DishedModel>> getCart() async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.cart,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final dishes = _handleResponse(response);
      return dishes;
    } on DioException catch (e) {
      handleError(e);
      return [];
    }
  }

  @override
  Future<void> updateStatus(String? status, String id) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.patch(
        "${Endpoints.orders}/status/$id",
        data: {"status": status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }

  @override
  Future<void> addToCart(String id, int quantity) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.post(
        Endpoints.cart,
        data: {"dishId": id, "quantity": quantity},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }

  @override
  Future<void> removeFromCart(String id) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.delete(
        Endpoints.cart,
        data: {"itemId": id},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }

  @override
  Future<void> updateCartItem(String id, int quantity) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.patch(
        Endpoints.cart,
        data: {"itemId": id, "quantity": quantity},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }
}

List<DishedModel> _handleResponse(Response response) {
  if (response.statusCode != 200) return [];
  try {
    final List<dynamic> jsonList = response.data['data']['items'];
    print('Items found: ${jsonList.length}');
    return jsonList.map((json) => DishedModel.fromJson(json)).toList();
  } catch (e) {
    throw const FormatException('Invalid user data format');
  }
}
