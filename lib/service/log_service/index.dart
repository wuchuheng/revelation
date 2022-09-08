import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class LogService {
  static Hook<List<LoggerItem>> logHook = Hook([]);

  static void push(LoggerItem loggerItem) {
    logHook.setCallback((data) {
      data.add(loggerItem);
      return data;
    });
  }
}
