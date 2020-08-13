import 'package:intl/intl.dart';

class DateTimeFormat {
  /// format type:
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String changeDatabaseStringToDisplayString(String data, String formatType) {
    int gmtHour = DateTime.now().timeZoneOffset.inHours;

    DateTime parsedDate =
        DateFormat('EEE, d MMM yyyy HH:mm:ss vvv').parse(data);
    DateTime gmt8Date = parsedDate.add(Duration(hours: gmtHour));
    return DateFormat(formatType).format(gmt8Date);
  }
}
