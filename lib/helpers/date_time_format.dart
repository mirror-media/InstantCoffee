import 'package:intl/intl.dart';

class DateTimeFormat {
  final int _offsetInHour = 8; // Asia/Taipei

  /// format type:
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String changeDatabaseStringToDisplayString(String data, String formatType,
      [String? postfix]) {
    DateTime parsedDate =
        DateFormat('EEE, d MMM yyyy HH:mm:ss vvv').parse(data);
    DateTime gmt8Date = parsedDate.add(Duration(hours: _offsetInHour));

    if (postfix is String && postfix.isNotEmpty) {
      return '${DateFormat(formatType).format(gmt8Date)} $postfix';
    } else {
      return DateFormat(formatType).format(gmt8Date);
    }
  }

  String changeYoutubeStringToDisplayString(String data, String formatType,
      [String? postfix]) {
    DateTime parsedDate = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(data);
    DateTime gmt8Date = parsedDate.add(Duration(hours: _offsetInHour));
    if (postfix is String && postfix.isNotEmpty) {
      return '${DateFormat(formatType).format(gmt8Date)} $postfix';
    } else {
      return DateFormat(formatType).format(gmt8Date);
    }
  }

  static DateTime? changeBirthdayStringToDatetime(String? data) {
    if (data == null) {
      return null;
    }

    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(data);
    return parsedDate;
  }

  static String changeDatetimeToIso8601String(DateTime data) {
    return data.toIso8601String().split('T')[0];
  }

  /// return string of duration in hh:mm:ss form(has pending 0)
  static String stringDuration(Duration? duration) {
    if (duration == null) {
      return "00:00";
    }

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //duration.toString()?.split('.')?.first ?? ''
    //return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
