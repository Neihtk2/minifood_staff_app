import 'package:get/get.dart';
import 'package:minifood_staff/data/repositories/message_repository.dart';

class MessageController extends GetxController {
  final MessageRepository _messageRepository = MessageRepository();

  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchMessagesByRoomId(String roomId) async {
    isLoading.value = true;
    try {
      final fetchedMessages = await _messageRepository.getMessagesByRoomId(roomId);
      messages.value = List<Map<String, dynamic>>.from(fetchedMessages);
    } catch (e) {
      errorMessage.value = 'Failed to fetch messages for room ID $roomId: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // save message
  Future<void> saveMessage(Map<String, dynamic> message) async {
    isLoading.value = true;
    try {
      await _messageRepository.saveMessage(message);
      messages.add(message); // Add the new message to the list
    } catch (e) {
      errorMessage.value = 'Failed to save message: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllMessages() async {
    isLoading.value = true;
    try {
      final fetchedMessages = await _messageRepository.getAllMessages();
      messages.value = List<Map<String, dynamic>>.from(fetchedMessages);
    } catch (e) {
      errorMessage.value = 'Failed to fetch all messages: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMessagesByUserId(String userId) async {
    isLoading.value = true;
    try {
      final fetchedMessages = await _messageRepository.getMessagesByUserId(userId);
      messages.value = List<Map<String, dynamic>>.from(fetchedMessages);
    } catch (e) {
      errorMessage.value = 'Failed to fetch messages for user ID $userId: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
