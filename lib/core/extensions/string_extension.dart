import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);

  T toEnum<T>(List<T> values) {
    return values.firstWhere(
        (e) => e.toString().toLowerCase().split(".").last == toLowerCase());
  }
}

extension DateTimeExtensions on String {
  String? formattedTaipeiDateTime() {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
    final outputFormat = DateFormat('yyyy.MM.dd HH:mm');

    try {
      final dateTime = inputFormat.parse(this).toLocal();
      final taipeiDateTime =
          dateTime.add(const Duration(hours: 8)); // 台北時間在 GMT+8

      return '${outputFormat.format(taipeiDateTime)} 台北時間';
    } catch (e) {
      return null;
    }
  }

  String? convertToCustomFormat() {
    try {
      DateTime dateTime = DateTime.parse(this);

      final customFormat = DateFormat('E, dd MMM yyyy HH:mm:ss');

      return customFormat.format(dateTime);
    } catch (e) {
      return null;
    }
  }
}
