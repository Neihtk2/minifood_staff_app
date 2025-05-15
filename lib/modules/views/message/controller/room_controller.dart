import 'package:get/get.dart';
import 'package:minifood_staff/data/repositories/room_repository.dart';

class RoomController extends GetxController {
  final RoomRepository _roomRepository = RoomRepository();

  var rooms = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    isLoading.value = true;
    try {
      final fetchedRooms = await _roomRepository.getAllRooms();
      rooms.value = List<Map<String, dynamic>>.from(fetchedRooms);
    } catch (e) {
      errorMessage.value = 'Failed to fetch rooms: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRoom(int customerId) async {
    isLoading.value = true;
    try {
      await _roomRepository.createRoom(customerId);
      fetchRooms(); // Refresh the room list after creating a new room
    } catch (e) {
      errorMessage.value = 'Failed to create room: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoomsByStaffId(int staffId) async {
    isLoading.value = true;
    try {
      final fetchedRooms = await _roomRepository.getRoomsByStaffId(staffId);
      rooms.value = List<Map<String, dynamic>>.from(fetchedRooms);
    } catch (e) {
      errorMessage.value = 'Failed to fetch rooms for staff ID $staffId: $e';
    } finally {
      isLoading.value = false;
    }
  }
}