import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime convertTimeStr(String timeString) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").parse(timeString);
  }
}
