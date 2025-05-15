// lib/presentation/controllers/auth_controller.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/core/constants/storage_constants.dart';
import 'package:minifood_staff/core/routes/app_routes.dart';
import 'package:minifood_staff/data/models/auth_model.dart';
import 'package:minifood_staff/data/repositories/auth_reponsitory.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository.instance;
  // final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isPasswordHidden = false.obs;
  final box = GetStorage();

  late IO.Socket socket;

  void _connectSocket(int userId, String role) {
    socket = IO.io(Endpoints.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to WebSocket server');
      socket.emit('joinUser', {'userId': userId, 'role': role});
    });

    socket.onDisconnect((_) => print('Disconnected from WebSocket server'));
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        final AuthModel? req = await _repo.login(email, password);

        if (req != null) {
          _saveTokens(req.token);
          _saveRole(req.role);
          _connectSocket(req.userId , req.role); // Kết nối WebSocket sau khi đăng nhập

          if (req.role == "staff") {
            Get.snackbar('Thành công', 'Đăng nhập thành công!');
            Get.offAllNamed(RouterName.HOME);
          } else if (req.role == "shipper") {
            Get.offAllNamed(RouterName.SHIPPERHOME);
          } else {
            Get.snackbar('Thông báo', 'Chỉ dành cho nhân viên!');
          }
        }
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // final response = await _apiService.LoginApp(username, password);
        final Response response = await _repo.register(name, email, password);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar(
            'Thành công',
            'Đăng ký thành công',
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar('Lỗi', 'Đăng ký không thành công');
        }
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _saveTokens(String? accessToken) {
    if (accessToken != null) {
      box.write(StorageConstants.accessToken, accessToken);
      // box.write(MyConfig.REFRESH_TOKEN, refreshToken);
    }
  }

  void _saveRole(String? role) {
    if (role != null) {
      box.write(StorageConstants.role, role);
      // box.write(MyConfig.REFRESH_TOKEN, refreshToken);
    }
  }

  Future<void> forgotpass(String email) async {}
}

void _handleError(dynamic e) {
  final message =
      e is DioException
          ? e.response?.data['message'] ?? e.message
          : e.toString();
  Get.snackbar('Error', message);
}
