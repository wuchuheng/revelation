import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime convertTimeStr(String timeString) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(timeString);
  }
}
