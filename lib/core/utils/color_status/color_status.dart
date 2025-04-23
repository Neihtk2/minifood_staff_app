// Helper function để xác định màu sắc và icon
import 'dart:ui';

import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return Colors.green;
    case 'delivering':
      return Colors.orange;
    case 'cancelled':
    case 'rejected':
      return Colors.red;
    case 'processing': // processing
      return Colors.amber;
    case 'pending':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

IconData getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return Icons.check_circle;
    case 'processing':
      return Icons.receipt_long;
    case 'delivering':
      return Icons.delivery_dining;
    case 'cancelled':
    case 'rejected':
      return Icons.cancel;
    case 'pending':
      return Icons.access_time;
    default:
      return Icons.help;
  }
}

String getStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return 'Đã giao';
    case 'processing':
      return 'Đã nhận đơn';
    case 'delivering':
      return 'Đang giao';
    case 'cancelled':
      return 'Đã hủy';
    case 'rejected':
      return 'Từ chối';
    case 'pending':
      return 'Chờ xác nhận';
    default:
      return 'Không xác định';
  }
}
