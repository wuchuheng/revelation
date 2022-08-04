import 'dart:async';
import 'dart:io';

/// 多路任务复用池声明
/// 多路任务复用是指同一时间调用多次任务，当已经有一个任务执行时，其它任务进行阻塞，等待任务完成时，
/// 把第一个任务的结果返回给其它的任务。
/// 这种模式适用于，当多次调用一个任务时，且任务的结果是固定的，那么当已经有一个任务有执行时，其它
/// 同样的任务可以不执行，等待第一个任务的结果，就可以，从而减少时间和资源的开销.
class TaskPool {
  List<Function()> taskRegisterList = []; // 任务注册列表

  static TaskPool builder() {
    return TaskPool();
  }

  Future<int> startTask() {
    int taskNum = DateTime.now().microsecondsSinceEpoch;
    Completer<int> c = Completer();
    taskRegisterList.add(() {
      print('${DateTime.now()} start task: $taskNum');
      c.complete(taskNum);
    });
    if (taskRegisterList.length == 1) {
      taskRegisterList[0]();
    }

    return c.future;
  }

  completeTask(int taskNum) {
    print('${DateTime.now()} completed task: $taskNum');
    taskRegisterList.removeAt(0);
    if (taskRegisterList.isNotEmpty) {
      try {
        taskRegisterList[0]();
      } catch (e) {
        sleep(const Duration(seconds: 1));
        taskRegisterList[0]();
      }
    }
  }
}
