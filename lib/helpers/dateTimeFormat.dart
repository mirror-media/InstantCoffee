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

  String changeYoutubeStringToDisplayString(String data, String formatType) {
    int gmtHour = DateTime.now().timeZoneOffset.inHours;

    DateTime parsedDate = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(data);
    DateTime gmt8Date = parsedDate.add(Duration(hours: gmtHour));
    return DateFormat(formatType).format(gmt8Date);
  }

  /// return string of duration in hh:mm:ss form(has pending 0)
  static String stringDuration(Duration duration) {
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
