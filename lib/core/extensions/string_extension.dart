import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}

extension DateTimeExtensions on String {
  String? formattedTaipeiDateTime() {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
    final outputFormat = DateFormat('yyyy.MM.dd HH:mm');

    try {
      final dateTime = inputFormat.parse(this).toLocal();
      final taipeiDateTime = dateTime.add(const Duration(hours: 8)); // 台北時間在 GMT+8

      return '${outputFormat.format(taipeiDateTime)} 台北時間';
    } catch (e) {
      return null;
    }
  }
}
