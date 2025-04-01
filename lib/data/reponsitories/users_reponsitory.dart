import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/api_constants.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/core/utils/error/error_func.dart';
import 'package:minifood_admin/data/models/user_model.dart';
import 'package:minifood_admin/data/sources/remote/api_service.dart';

abstract class UsersReponsitory {
  Future<List<UserModel>> getAllUsers(String? role);
}

class UsersRepositoryImpl implements UsersReponsitory {
  final ApiService api = Get.find();
  static final UsersRepositoryImpl _instance = UsersRepositoryImpl._internal();
  UsersRepositoryImpl._internal();
  final box = GetStorage();
  static UsersRepositoryImpl get instance => _instance;
  @override
  Future<List<UserModel>> getAllUsers(String? role) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.getAllUsers,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final users = _handleResponse(response);
      if (role != null) {
        return users.where((user) => user.role == role).toList();
      }
      return users;
    } on DioException catch (e) {
      handleError(e);
      return [];
    }
  }
}

List<UserModel> _handleResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201) return [];
  try {
    final List<dynamic> jsonList = response.data;
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  } catch (e) {
    throw const FormatException('Invalid user data format');
  }
}
