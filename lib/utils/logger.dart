class Logger {
  static bool debugger = true;

  static void info({
    required String message,
    required String symbol,
  }) {
    if (debugger) {
      print('$symbol:${DateTime.now().toString()} $message');
    }
  }
}
