import 'package:minifood_staff/data/models/dished_model.dart';

class OrdersModel {
  String id;
  int userId;
  String customerName;
  String phone;
  String deliveryAddress;
  String paymentMethod;
  List<DishedModel> items;
  int total;
  String status;
  String? couponCode;
  String shipper;
  String shipperPhone;
  DateTime createdAt;
  DateTime? updatedAt;

  OrdersModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.phone,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.items,
    required this.total,
    required this.shipper,
    required this.shipperPhone,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.couponCode,
  });
  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
    id: json["_id"],
    userId: json["userId"],
    customerName: json["customerName"],
    phone: json["phone"],
    deliveryAddress: json["deliveryAddress"],
    paymentMethod: json["paymentMethod"],
    items: List<DishedModel>.from(
      json["items"].map((x) => DishedModel.fromJson(x)),
    ),
    total: json["total"],
    status: json["status"],
    couponCode: json["voucher"] ?? "",
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    shipper: json["shipper"] ?? "",
    shipperPhone: json["phoneShipper"] ?? "",
  );
}
