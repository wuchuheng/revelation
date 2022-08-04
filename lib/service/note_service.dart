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
    await Future.wait([
      cacheServiceInstance.set(
          key: 'tmp', value: '{"id": "replay", "pid": 1312312312}'),
      cacheServiceInstance.set(
          key: 'tmptmp', value: '{"id": "replay", "pid": 212312312}'),
      cacheServiceInstance.set(
          key: 'hello', value: '{"id": "replay", "pid": 212312312}'),
    ]);
    // await cacheServiceInstance.unset(name: 'tmp');
    String tmpData = await cacheServiceInstance.get(key: 'tmp');
  }
}
