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
}
