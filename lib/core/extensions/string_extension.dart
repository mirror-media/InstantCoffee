import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}

extension DateTimeExtensions on String {
  String? formattedDateTime() {
    final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
    final outputFormat = DateFormat('yyyy.MM.dd HH:mm');

    try {
      final dateTime = inputFormat.parse(this).toLocal();
      return outputFormat.format(dateTime);
    } catch (e) {
      return null;
    }
  }
}
