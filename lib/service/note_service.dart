import 'package:snotes/service/cache_service/utils/single_task_pool.dart';

import 'cache_service/cache_service.dart';

class NoteService {
  static SingleTaskPool singleTaskPool = SingleTaskPool.builder();
  Future<void> tmp() async {
    await Future.delayed(const Duration(seconds: 3));
    print('OK');
  }

  createFold(String fold) async {
    final cacheServiceInstance = await CacheService.getInstance();
    await cacheServiceInstance.connectToServer();
    final subscriptionHandler = cacheServiceInstance.setEventSubscribe(key: 'tmp', callback: (a) {
        print('set data $a');
      });
    cacheServiceInstance.unsetEventSubscribe(key: 'tmp', callback:  ({required String key}) {
      print('unset data $key');
    });
    cacheServiceInstance.startSyncEvent(() => print('Start sync') );
    cacheServiceInstance.completedSyncEvent(() => print('completed sync') );


    await Future.wait([
      cacheServiceInstance.set(
          key: 'tmp', value: '{"id": "replay", "pid": 1312312312}'),
      cacheServiceInstance.set(
          key: 'tmptmp', value: '{"id": "replay", "pid": 212312312}'),
      cacheServiceInstance.set(
          key: 'hello', value: '{"id": "replay", "pid": 212312312}'),
    ]);
    await cacheServiceInstance.unset(key: 'tmp');

    String hello = await cacheServiceInstance.get(key: 'hello');
    print(hello);
  }
}
