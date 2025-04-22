import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/api_constants.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/data/models/dished_model.dart';
import 'package:minifood_admin/data/sources/remote/api_service.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

abstract class DishedReponsitory {
  Future<List<DishedModel>> getDishes(String? category);
  Future<DishedModel?> getDishedbyId(String id);
  Future<void> deleteDished(String id);
  Future<Response> createDish({
    required String name,
    required int price,
    required String category,
    required File imageFile,
    required String token,
  });
  Future<Response> updateDished(
    String id,
    String? name,
    int? price,
    String? category,
    File? imageFile,
    String token,
  );
}

class DishedReponsitoryImpl implements DishedReponsitory {
  final ApiService api = Get.find();
  static final DishedReponsitoryImpl _instance =
      DishedReponsitoryImpl._internal();
  DishedReponsitoryImpl._internal();
  static DishedReponsitoryImpl get instance => _instance;
  final box = GetStorage();
  @override
  Future<Response> createDish({
    required String name,
    required int price,
    required String category,
    required File imageFile,
    required String token,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        'name': name,
        'price': price,
        'category': category,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename:
              'dish_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}',
          contentType: MediaType('image', 'jpeg'),
        ),
      });
      final response = await api.dio.post(
        Endpoints.dishes,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
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

  @override
  Future<Response> deleteDished(String id) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.delete(
        '${Endpoints.dishes}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return e.response!;
    }
  }

  @override
  Future<List<DishedModel>> getDishes(String? category) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.dishes,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final dishes = _handleResponse(response);
      if (category != null) {
        return dishes.where((dish) => dish.category == category).toList();
      }
      return dishes;
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }

  @override
  Future<Response> updateDished(
    String id,
    String? name,
    int? price,
    String? category,
    File? imageFile,
    String token,
  ) async {
    try {
      final formData = FormData();
      if (name != null) formData.fields.add(MapEntry('name', name));
      if (price != null) {
        formData.fields.add(MapEntry('price', price.toString()));
      }
      if (category != null) formData.fields.add(MapEntry('category', category));

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename:
                  'dish_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}',
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await api.dio.put(
        '${Endpoints.dishes}/$id',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print("Lỗi từ server: ${e.response}");
        return e.response!;
      } else {
        throw Exception('Lỗi kết nối: ${e.message}');
      }
    }
  }

  @override
  Future<DishedModel?> getDishedbyId(String id) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.dishes + "/" + id,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final dishes = DishedModel.fromJson(response.data["data"]);
      return dishes;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }
}

List<DishedModel> _handleResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201) return [];
  try {
    final List<dynamic> jsonList = response.data["data"];
    return jsonList.map((json) => DishedModel.fromJson(json)).toList();
  } catch (e) {
    throw const FormatException('Invalid user data format');
  }
}

void _handleError(dynamic error) {
  if (error is DioException) {
    Get.snackbar('Error', error.response?.data['message'] ?? error.message);
  } else {
    Get.snackbar('Error', error.toString());
  }
}
