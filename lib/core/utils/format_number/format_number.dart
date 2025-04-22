import 'package:intl/intl.dart';

String formatNumberWithComma(num number) {
  final formatter = NumberFormat.decimalPattern('en_US');
  return formatter.format(number);
}
