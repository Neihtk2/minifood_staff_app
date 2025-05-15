import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minifood_staff/modules/views/profile/profile_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int roomId;

  ChatScreen({required this.roomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  String errorMessage = '';
  late IO.Socket socket;
  final ProfileController prf = Get.find();
  late final user;

  @override
  void initState() {
    super.initState();
    user = prf.profile.value;
    connectSocket();
  }

  void connectSocket() {
    socket = IO.io('http://<YOUR_BACKEND_HOST>:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');

      // Gửi thông tin user khi kết nối
      socket.emit('joinUser', {
        'userId': user['_id'],
        'role': user['role'], // "staff" hoặc "user"
      });

      // Tham gia phòng chat
      socket.emit('joinRoom', {'roomId': widget.roomId});
    });

    // Khi nhận tin nhắn mới từ server
    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add({
          'senderId': data['senderId'],
          'senderRole': data['senderRole'],
          'message': data['message'],
          'timestamp': DateTime.now().toString(), // Hoặc data['timestamp'] nếu server gửi
        });
      });
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onConnectError((err) {
      setState(() {
        errorMessage = "Không thể kết nối tới server.";
      });
    });

    socket.onError((err) {
      setState(() {
        errorMessage = "Có lỗi xảy ra.";
      });
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final data = {
      'roomId': widget.roomId,
      'senderId': user['_id'],
      'senderRole': user['role'], // "staff"
      'message': message,
    };

    socket.emit('sendMessage', data);

    setState(() {
      messages.add({
        'senderId': user['_id'],
        'senderRole': user['role'],
        'message': message,
        'timestamp': DateTime.now().toString(),
      });
    });

    _controller.clear();
  }

  String formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return DateFormat('HH:mm dd/MM').format(dt);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phòng chat #${widget.roomId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(child: Text('Chưa có tin nhắn nào.'))
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isStaff = msg['senderRole'] == 'staff';

                          return ListTile(
                            title: Align(
                              alignment: isStaff
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isStaff
                                      ? Colors.blueAccent
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  msg['message'] ?? '',
                                  style: TextStyle(
                                    color:
                                        isStaff ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Align(
                              alignment: isStaff
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                formatTimestamp(msg['timestamp']),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(errorMessage, style: TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
