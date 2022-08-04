import 'dart:async';

/// 多路任务复用池
class MultiplexTaskPool {
  List<Function<T>({required bool isResult, T? result})> callbackList = [];

  static MultiplexTaskPool builder() {
    return MultiplexTaskPool();
  }

  Future<T> start<T>(Future<T> Function() callback) async {
    Completer<T> completer = Completer();
    callbackList.add(
      <B>({required bool isResult, B? result}) async {
        if (isResult) {
          return completer.complete(result as T);
        } else {
          T finalResult = await callback();
          for (var i = 0; i < callbackList.length; i++) {
            await callbackList[i](isResult: true, result: finalResult);
          }
          callbackList.clear();
        }
      },
    );
    if (callbackList.length == 1) {
      callbackList[0](isResult: false);
    }

    return completer.future;
  }
}
