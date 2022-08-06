import 'dart:async';
import 'dart:io';

/// 多路任务复用池
class MultiplexTaskPool {
  List<Function<T>({required bool isResult, T? result, Exception? error})> callbackList = [];

  static MultiplexTaskPool builder() {
    return MultiplexTaskPool();
  }

  Future<T> start<T>(Future<T> Function() callback) {
    Completer<T> completer = Completer();
    callbackList.add(
      <B>({required bool isResult, B? result, Exception? error}) {
        if (isResult) {
          error != null ? completer.completeError(error) : completer.complete(result as T);
        } else {
            callback().then((finalResult) {
              for (var i = 0; i < callbackList.length; i++) {
                callbackList[i](isResult: true, result: finalResult);
              }
              callbackList.clear();
            }).catchError((e, track) {
              print(e);
              print(track);
              for(var callback in callbackList) {
                callback(isResult: true, result: null, error: e);
              }
              callbackList.clear();
            });
        }
      },
    );
    if (callbackList.length == 1) {
      callbackList[0](isResult: false);
    }

    return completer.future;
  }
}
