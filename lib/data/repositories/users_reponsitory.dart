import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/core/utils/error/error_func.dart';
import 'package:minifood_staff/data/models/user_model.dart';
import 'package:minifood_staff/data/sources/remote/api_service.dart';

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
  @override
  Future<Response> updateProfile(UserModel user, {XFile? imageFile}) async {
    final token = box.read(StorageConstants.accessToken);
    try {
      final formMap = Map<String, dynamic>.from(user.toJson());

      // Nếu có ảnh thì thêm vào map
      if (imageFile != null) {
        final file = await MultipartFile.fromFile(
          imageFile.path,
          filename: 'user_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        formMap['image'] = file;
      }

      final formData = FormData.fromMap(formMap);

      final response = await api.dio.put(
        Endpoints.profile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // KHÔNG cần set Content-Type thủ công nếu dùng FormData
            // Dio sẽ tự đặt đúng boundary cho multipart
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      handleError(e);
      return e.response!;
    }
  }

  // Future<Response> updateProfile(UserModel user, {XFile? imageFile}) async {
  //   final token = box.read(StorageConstants.accessToken);
  //   try {
  //     FormData formData;

  //     // Nếu có ảnh mới được chọn
  //     if (imageFile != null) {
  //       formData = FormData.fromMap({
  //         ...user.toJson(),
  //         'image': await MultipartFile.fromFile(
  //           imageFile.path,
  //           filename: 'user_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //           contentType: MediaType('image', 'jpeg'),
  //         ),
  //       });
  //     } else {
  //       formData = FormData.fromMap(user.toJson());
  //     }

  //     final response = await api.dio.put(
  //       Endpoints.profile,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'multipart/form-data',
  //         },
  //       ),
  //     );

  //     return response;
  //   } on DioException catch (e) {
  //     handleError(e);
  //     return e.response!;
  //   }
  // }
  // Future<Response> updateProfile(UserModel user) async {
  //   final token = box.read(StorageConstants.accessToken);
  //   try {
  //     final response = await api.dio.put(
  //       Endpoints.profile,
  //       data: user.toJson(),
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );
  //     return response;
  //   } on DioException catch (e) {
  //     handleError(e);
  //     return e.response!;
  //   }
  // }

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
