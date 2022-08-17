import 'dart:async';

typedef DebounceHandlerCallback<T> = Function(T value);

class Helper {
  /// 防抖
  static Function(T value) debounce<T>(
    Function(T value) callback,
    int milliseconds,
  ) {
    Timer? timer;
    return (T data) {
      timer?.cancel();
      timer = Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
        timer.cancel();
        callback(data);
      });
    };
  }
}
