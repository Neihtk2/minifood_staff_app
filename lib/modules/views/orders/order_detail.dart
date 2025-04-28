import 'package:flutter/material.dart';
import 'package:minifood_staff/core/utils/color_status/color_status.dart';
import 'package:minifood_staff/data/models/orders_model.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrdersModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Khách hàng'),
            _infoRow('Tên:', order.customerName),
            _infoRow('SĐT:', order.phone),
            _infoRow('Địa chỉ:', order.deliveryAddress),

            const SizedBox(height: 16),
            _sectionTitle('Thông tin đơn hàng'),
            _infoRow('Mã đơn:', order.id),
            _infoRow('Thanh toán:', order.paymentMethod),
            _statusRow(order.status),
            _infoRow('Ngày tạo:', dateFormat.format(order.createdAt)),
            _infoRow("Mã giảm giá: ", order.couponCode ?? ""),
            const SizedBox(height: 16),
            _sectionTitle('Món đã đặt'),
            const SizedBox(height: 8),
            ...order.items.map(
              (item) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Image.network(
                    item.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    'Số Lượng: ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    currency.format(item.price * item.quantity),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Tổng cộng: ${currency.format(order.total)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,

        color: Colors.blueGrey,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Trạng thái:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Icon(
                  getStatusIcon(status),
                  color: getStatusColor(status),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  getStatusText(status),
                  style: TextStyle(
                    color: getStatusColor(status),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
