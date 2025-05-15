import 'package:get/get.dart';
import '../sources/remote/api_service.dart';

class MessageRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<dynamic>> getMessagesByRoomId(String roomId) async {
    try {
      final response = await _apiService.dio.get('/messages/room/$roomId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch messages for room ID $roomId: $e');
    }
  }

  Future<List<dynamic>> getAllMessages() async {
    try {
      final response = await _apiService.dio.get('/messages');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch all messages: $e');
    }
  }

  Future<List<dynamic>> getMessagesByUserId(String userId) async {
    try {
      final response = await _apiService.dio.get('/messages/user/$userId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch messages for user ID $userId: $e');
    }
  }

  Future<void> saveMessage(Map<String, dynamic> message) async {
    try {
      await _apiService.dio.post('/messages/save', data: message);
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }
}
