import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class LogService {
  static Hook<List<LoggerItem>> logHook = Hook([]);
  static int maxLogLength = 0;
  static int _calculationLogIndex = 0;

  static void push(LoggerItem loggerItem) {
    logHook.setCallback((data) {
      data.add(loggerItem);
      return data;
    });
    final value = logHook.value;
    while (_calculationLogIndex != value.length) {
      final log = value[_calculationLogIndex];
      int logLength = log.type.name.length;
      logLength += log.message.length;
      logLength += log.symbol?.length ?? 0;
      logLength += log.file.length;
      if (maxLogLength < logLength) maxLogLength = logLength;
      _calculationLogIndex++;
    }
  }
}
