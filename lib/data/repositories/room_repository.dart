import 'package:get/get.dart';
import '../sources/remote/api_service.dart';

class RoomRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<int, dynamic>> createRoom(int customerId) async {
    try {
      final response = await _apiService.dio.post('/rooms', data: {
        'customerId': customerId,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }

  Future<List<dynamic>> getAllRooms() async {
    try {
      final response = await _apiService.dio.get('/rooms');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch rooms: $e');
    }
  }

  Future<List<dynamic>> getRoomsByStaffId(int staffId) async {
    try {
      final response = await _apiService.dio.get('/rooms/staff/$staffId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch rooms for staff ID $staffId: $e');
    }
  }
}
