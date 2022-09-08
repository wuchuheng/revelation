import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime convertTimeStr(String timeString) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(timeString);
  }

  static String _formatNumStr(int num) => num > 9 ? '$num' : '0$num';

  static String formatSecond(DateTime dateTime) => _formatNumStr(dateTime.second);

  static String formatMinute(DateTime dateTime) => _formatNumStr(dateTime.minute);

  static String formatHour(DateTime dateTime) => _formatNumStr(dateTime.hour);
}
