import 'package:intl/intl.dart';
import 'package:minifood_admin/core/utils/format_number/format_number.dart';

class Voucher {
  final String id;
  final String code;

  final int value;
  final int minOrderValue;
  final double? maxDiscountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxUses;
  final int? maxUsagePerUser;
  final int usedCount;
  List<UserUsage> usersUsage;
  final String image;
  final bool isActive;

  final bool? isValid;

  Voucher({
    this.id = '',
    required this.code,

    required this.value,
    required this.minOrderValue,
    this.maxDiscountAmount,
    required this.startDate,
    required this.endDate,
    this.maxUses,
    this.maxUsagePerUser,
    this.usedCount = 0,
    List<UserUsage>? usersUsage,
    this.image = '',
    this.isActive = true,

    this.isValid,
  }) : usersUsage = usersUsage ?? [];
  String get formattedStartDate => DateFormat('dd-MM-yyyy').format(startDate);
  String get formattedEndDate => DateFormat('dd-MM-yyyy').format(endDate);
  String get formattedValue => formatNumberWithComma(value);
  String get formattedMinOrderValue => formatNumberWithComma(minOrderValue);
  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['_id'],
      code: json['code'],

      value: (json['value'] as num).toInt(),
      minOrderValue: (json['minOrderValue'] as num).toInt(),

      maxDiscountAmount:
          json['maxDiscountAmount'] != null
              ? double.parse(json['maxDiscountAmount'].toString())
              : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxUses: json['maxUses'],
      maxUsagePerUser: json['maxUsagePerUser'],
      usedCount: json['usedCount'] ?? 0,
      usersUsage:
          (json['usersUsage'] as List?)
              ?.map((u) => UserUsage.fromJson(u))
              .toList() ??
          [],
      image: json['image'] ?? '',
      isActive: json['isActive'] ?? true,
      isValid: json['isValid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,

      'value': value,
      'minOrderValue': minOrderValue,
      'maxDiscountAmount': maxDiscountAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxUses': maxUses,
      'maxUsagePerUser': maxUsagePerUser,
    };
  }

  // String get formattedMinOrder {
  //   final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  //   return formatter.format(minOrderValue);
  // }

  String get validity {
    final formatter = DateFormat('dd/MM/yyyy');
    return "${formatter.format(startDate)} - ${formatter.format(endDate)}";
  }
}

class UserUsage {
  final String userId;
  final int count;

  UserUsage({required this.userId, required this.count});

  factory UserUsage.fromJson(Map<String, dynamic> json) {
    return UserUsage(userId: json['userId'], count: json['count']);
  }
}
