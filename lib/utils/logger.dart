import 'package:snotes/config/config.dart';
import 'package:stack_trace/stack_trace.dart';

class Logger {
  static bool debugger = Config.isDebug;

  static void info({
    required String message,
    required String symbol,
  }) {
    if (debugger) {
      final chain = Chain.forTrace(StackTrace.current);
      final frames = chain.toTrace().frames;
      final frame = frames[1];
      final file = '${frame.uri}:${frame.line}:${frame.column}';

      print('\x1B[32m INFO ${DateTime.now().toString()}: $message $file symbol: $symbol \x1B[0m');
    }
  }

  static void error({
    required String message,
    required String symbol,
  }) {
    if (debugger) {
      final chain = Chain.forTrace(StackTrace.current);
      final frames = chain.toTrace().frames;
      final frame = frames[1];
      final file = '${frame.uri}:${frame.line}:${frame.column}';

      print('\x1B[31m ERROR ${DateTime.now().toString()}: $message $file symbol: $symbol \x1B[0m');
    }
  }
}
