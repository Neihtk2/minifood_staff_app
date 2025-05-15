import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/core/utils/error/error_func.dart';
import 'package:minifood_staff/data/models/orders_model.dart';
import 'package:minifood_staff/data/sources/remote/api_service.dart';

abstract class OrdersReponsitory {
  Future<List<OrdersModel>> getAllOrders(String? status);
  Future<void> creatOrder(
    String customerName,
    String phone,
    String paymentMethod,
    int orderTotal,
    String? voucherCode,
  );
  Future<void> updateStatus(String? status, String id);
  Future<List<OrdersModel>> getPendingDelivery();
  Future<void> acceptOrderForDelivery(String id);
  Future<List<OrdersModel>> getAcceptedDeliveryOrders();
}

class OrdersRepositoryImpl implements OrdersReponsitory {
  final ApiService api = Get.find();
  static final OrdersRepositoryImpl _instance =
      OrdersRepositoryImpl._internal();
  OrdersRepositoryImpl._internal();
  final box = GetStorage();
  static OrdersRepositoryImpl get instance => _instance;
  @override
  Future<List<OrdersModel>> getAllOrders(String? status) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.orders,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final orders = _handleResponse(response);
      if (status != null) {
        return orders.where((order) => order.status == status).toList();
      }
      return orders;
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
  Future<void> creatOrder(
    String customerName,
    String phone,

    String paymentMethod,
    int orderTotal,
    String? voucherCode,
  ) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.post(
        Endpoints.orders,
        data: {
          "customerName": customerName,
          "phone": phone,
          "deliveryAddress": "Bán tại quầy",
          "paymentMethod": paymentMethod,
          "orderTotal": orderTotal,
          "voucherCode": voucherCode,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }

  @override
  Future<void> acceptOrderForDelivery(String id) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      await api.dio.patch(
        "${Endpoints.getPendingDelivery}/$id",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
    }
  }

  @override
  Future<List<OrdersModel>> getAcceptedDeliveryOrders() async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.getAcceptedDelivery,
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
  Future<List<OrdersModel>> getPendingDelivery() async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.getPendingDelivery,
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

List<OrdersModel> _handleResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201) return [];
  try {
    final List<dynamic> jsonList = response.data['data'];
    return jsonList.map((json) => OrdersModel.fromJson(json)).toList();
  } catch (e) {
    throw const FormatException('Invalid user data format');
  }
}
