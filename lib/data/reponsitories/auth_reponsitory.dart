import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/data/models/auth_model.dart';
import 'package:minifood_staff/data/sources/remote/api_service.dart';

abstract class AuthRepositoryService {
  Future<AuthModel?> login(String email, String password);
  Future<Response> register(String username, String email, String password);
  Future<void> logout();
}

class AuthRepository implements AuthRepositoryService {
  final ApiService _api = Get.find();
  static final AuthRepository _instance = AuthRepository._internal();
  AuthRepository._internal();
  static AuthRepository get instance => _instance;

  @override
  Future<AuthModel?> login(String email, String password) async {
    try {
      final response = await _api.dio.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  @override
  Future<Response> register(
    String username,
    String email,
    String password,
  ) async {
    return await _api.dio.post(
      Endpoints.register,
      data: {
        'name': username,
        'email': email,
        'password': password,
        // 'role': "user",
      },
    );
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}

AuthModel? _handleResponse(Response response) {
  if (response.statusCode != 200 && response.statusCode != 201) return null;
  try {
    return AuthModel.fromJson(response.data);
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
