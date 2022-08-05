import 'package:intl/intl.dart';

class TimerUtil {
  static int timeStringConvertMilliseconds(String time) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").parse(time).millisecondsSinceEpoch;
  }
}
