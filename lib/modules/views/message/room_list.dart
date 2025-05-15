import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/message/chat_screen.dart';

import 'controller/room_controller.dart';

class RoomListScreen extends StatelessWidget {
  final RoomController roomController = Get.put(RoomController());

  RoomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int staffId = 4; // Replace with actual staff ID
    roomController.fetchRoomsByStaffId(staffId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách phòng hỗ trợ'),
      ),
      body: Obx(() {
        if (roomController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (roomController.errorMessage.isNotEmpty) {
          return Center(child: Text(roomController.errorMessage.value));
        }

        return ListView.builder(
          itemCount: roomController.rooms.length,
          itemBuilder: (context, index) {
            final room = roomController.rooms[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(room['avatarUrl'] ?? ''),
              ),
              title: Text('Phòng ${room['roomId']}'),
              subtitle: Text('Khách hàng: ${room['customerId']}'),
              onTap: () {
                // Chuyển sang màn hình ChatScreen với thông tin phòng và danh sách tin nhắn
                Get.to(() => ChatScreen(roomId: room['roomId']));
              },
            );
          },
        );
      }),
    );
  }
}
