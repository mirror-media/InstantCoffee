import 'package:intl/intl.dart';

class DateTimeFormat {
  String changeDatabaseStringToDisplayString(String data, String formatType) {
    int gmtHour = DateTime.now().timeZoneOffset.inHours;
    
    DateTime parsedDate = DateFormat('EEE, d MMM yyyy HH:mm:ss vvv').parse(data);
    DateTime gmt8Date = parsedDate.add(Duration(hours: gmtHour));
    return DateFormat(formatType).format(gmt8Date);
  }
}