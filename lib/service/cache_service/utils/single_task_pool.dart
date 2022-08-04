import 'dart:async';

class SingleTaskPool {
  List<Future Function()> taskRegisterList = []; // 任务注册列表

  static SingleTaskPool builder() {
    return SingleTaskPool();
  }

  Future<void> start(Future Function() callback) async {
    Completer completer = Completer();
    taskRegisterList.add(() async {
      await callback();
      taskRegisterList.removeAt(0);
      completer.complete();
      if (taskRegisterList.isNotEmpty) {
        await taskRegisterList[0]();
      }
    });
    if (taskRegisterList.length == 1) {
      await taskRegisterList[0]();
    }

    return completer.future;
  }
}
