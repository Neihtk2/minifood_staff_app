import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minifood_staff/core/constants/api_constants.dart';
import 'package:minifood_staff/data/sources/remote/api_service.dart';
import 'package:minifood_staff/modules/views/orders/order_detail.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class FCMService {
  ApiService apiService = Get.find<ApiService>();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final box = GetStorage();

  static Future<void> initialize() async {
    // Cấu hình local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Cấu hình FCM
    await _setupFCM();
  }

  static Future<void> _setupFCM() async {
    // Yêu cầu quyền (iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Lấy token
    String? token = await _fcm.getToken();
    if (token != null) {
      await _saveToken(token);
    }
    _fcm.onTokenRefresh.listen(_saveToken);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageClicked);
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageClicked(initialMessage);
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('device_id') ?? const Uuid().v4();
    await prefs.setString('device_id', deviceId);
    await prefs.setString('fcm_token', token);
    await _sendTokenToServer(token, deviceId);
  }

  static Future<void> _sendTokenToServer(String token, String deviceId) async {
    try {
      await ApiService().dio.post(
        Endpoints.fcm,
        data: {'device_id': deviceId, 'fcm_token': token},
      );
    } catch (e) {
      print('Lỗi gửi FCM token: $e');
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'order_channel',
          'Order Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  static void _handleMessageClicked(RemoteMessage message) {
    // Xử lý điều hướng khi nhấn vào thông báo
    if (message.data['type'] == 'ORDER_STATUS_UPDATE') {
      Get.to(OrderDetailScreen(order: message.data['orderId']));
    }
  }
}
