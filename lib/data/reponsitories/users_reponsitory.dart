import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_admin/core/constants/api_constants.dart';
import 'package:minifood_admin/core/constants/storage_constants.dart';
import 'package:minifood_admin/core/utils/error/error_func.dart';
import 'package:minifood_admin/data/models/user_model.dart';
import 'package:minifood_admin/data/sources/remote/api_service.dart';

abstract class UsersReponsitory {
  Future<UserModel?> profile();
  Future<Response> updateProfile(UserModel user);
  Future<Response> changePassword(String oldPassword, String newPassword);
}

class UsersRepositoryImpl implements UsersReponsitory {
  final ApiService api = Get.find();
  static final UsersRepositoryImpl _instance = UsersRepositoryImpl._internal();
  UsersRepositoryImpl._internal();
  final box = GetStorage();
  static UsersRepositoryImpl get instance => _instance;
  @override
  Future<UserModel?> profile() async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.get(
        Endpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final user = profileResponse(response);
      return user;
    } on DioException catch (e) {
      handleError(e);
      return null;
    }
  }

  @override
  Future<Response> updateProfile(UserModel user) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final response = await api.dio.put(
        Endpoints.profile,
        data: user.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      handleError(e);
      return e.response!;
    }
  }

  @override
  Future<Response> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      return await api.dio.post(
        Endpoints.changePassword,
        data: {'currentPassword': oldPassword, 'newPassword': newPassword},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleError(e);
      return e.response!;
    }
  }
}

UserModel? profileResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201) return null;
  try {
    final json = response.data['data'];
    return UserModel.fromJson(json);
  } catch (e) {
    throw const FormatException('Invalid user data format');
  }
}
