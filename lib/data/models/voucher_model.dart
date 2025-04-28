import 'package:intl/intl.dart';
import 'package:minifood_staff/core/utils/format_number/format_number.dart';

class Voucher {
  final String id;
  final String code;
  final int value;
  final int minOrderValue;
  final int? maxUses;
  final DateTime startDate;
  final DateTime endDate;

  final int? maxUsagePerUser;
  final int usedCount;
  List<UserUsage> usersUsage;
  final String image;
  final bool isActive;
  bool isValid;

  Voucher({
    this.id = '',
    required this.code,

    required this.value,
    required this.minOrderValue,

    required this.startDate,
    required this.endDate,
    this.maxUses,
    this.maxUsagePerUser,
    this.usedCount = 0,
    List<UserUsage>? usersUsage,
    this.image = '',
    this.isActive = true,

    this.isValid = false,
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
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxUses: json['maxUses'] != null ? (json['maxUses'] as num).toInt() : 0,
      maxUsagePerUser: json['maxUsagePerUser'],
      usedCount: json['usedCount'] ?? 0,
      usersUsage:
          (json['usersUsage'] as List?)
              ?.map((u) => UserUsage.fromJson(u))
              .toList() ??
          [],
      image: json['image'] ?? '',
      isActive: json['isActive'] ?? true,
      isValid: json['isValid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'value': value,
      'minOrderValue': minOrderValue,

      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),

      'maxUsagePerUser': maxUsagePerUser,
    };
  }

  String get validity {
    final formatter = DateFormat('dd/MM/yyyy');
    return "${formatter.format(startDate)} - ${formatter.format(endDate)}";
  }
}

class UserUsage {
  final int userId;
  final int count;

  UserUsage({required this.userId, required this.count});

  factory UserUsage.fromJson(Map<String, dynamic> json) {
    return UserUsage(userId: json['userId'], count: json['count']);
  }
}
