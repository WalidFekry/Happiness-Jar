import 'package:easy_localization/easy_localization.dart';

class DateTimeHelper {
  /// Helper method to format time
  static String formatTime(int? seconds) {
    int minutes = seconds! ~/ 60;
    int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  /// Helper method to format timestamp
  static String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate =
        DateFormat('EEEE، d MMMM yyyy - hh:mm a', 'ar').format(dateTime);
    return formattedDate;
  }

  /// Helper method to format time spent
  static String formatTimeSpent(int? seconds) {
    int minutes =
        (seconds! / 60).ceil();
    if (minutes == 1) {
      return "دقيقة واحدة";
    } else if (minutes == 2) {
      return "دقيقتان";
    } else if (minutes >= 3 && minutes <= 10) {
      return "$minutes دقائق";
    } else {
      return "$minutes دقيقة";
    }
  }
}
