import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime convertTimeStr(String timeString) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(timeString);
  }

  static String _formatNumStr(int num) => num > 9 ? '$num' : '0$num';

  static String formatSecond(DateTime dateTime) => _formatNumStr(dateTime.second);

  static String formatMinute(DateTime dateTime) => _formatNumStr(dateTime.minute);

  static String formatHour(DateTime dateTime) => _formatNumStr(dateTime.hour);
  static String formatDay(DateTime dateTime) => _formatNumStr(dateTime.day);

  static String formatDateTime(DateTime dateTime) {
    final second = DateTimeUtil.formatSecond(dateTime);
    final minute = DateTimeUtil.formatMinute(dateTime);
    final hour = DateTimeUtil.formatHour(dateTime);
    final day = DateTimeUtil.formatDay(dateTime);

    return '${dateTime.year}-${dateTime.month}-$day $hour:$minute:$second';
  }
}
