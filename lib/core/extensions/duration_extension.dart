extension DurationExtension on Duration {
  String formatDuration() {

    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hoursStr:$minutesStr:$secondsStr';
    } else if (minutes > 0) {
      return '$minutesStr:$secondsStr';
    } else {
      return '00:$secondsStr';
    }
  }
  String toFormattedString() {
    int seconds = inSeconds.remainder(60);
    String secondsStr = seconds.toString().padLeft(2, '0');
    if (inDays > 0) {
      return '$inDays:${inHours.remainder(24)}: ${inMinutes.remainder(60)}:${secondsStr}';
    } else if (inHours > 0) {
      return '$inHours:${inMinutes.remainder(60)}$secondsStr';
    } else if (inMinutes > 0) {
      return '$inMinutes:$secondsStr';
    } else {
      return '00:$secondsStr';
    }
  }

}
