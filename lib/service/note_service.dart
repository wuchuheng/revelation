import 'dart:io';
import 'cache_service/cache_service.dart';

class NoteService {
  createFold(String fold) async {
    late CacheService cacheServiceInstance;
    try {
       cacheServiceInstance = await CacheService().connectToServer(
        userName: '2831473954@qq.com',
        password: 'owtdtjnltfnndegh',
        imapServerHost: 'local.wuchuheng.com',
        imapServerPort: 993,
        isImapServerSecure: true,
        boxName: 'snotes',
        registerMailBox: 'snotes_register',
      );
    } on SocketException {
      rethrow;
    }
    // cacheServiceInstance.unsetEventSubscribe(key: 'tmp', callback:  ({required String key}) {
    //   print('unset data $key');
    // });
    // cacheServiceInstance.startSyncEvent(() => print('Start sync') );
    // cacheServiceInstance.completedSyncEvent(() => print('completed sync') );

    // await Future.wait([
    //   cacheServiceInstance.set(
    //       key: 'tmp', value: '{"id": "replay", "pid": 1312312312}'),
    //   cacheServiceInstance.set(
    //       key: 'tmptmp', value: '{"id": "replay", "pid": 212312312}'),
    //   cacheServiceInstance.set(
    //       key: 'hello', value: '{"id": "replay", "pid": 212312312}'),
    // ]);
    // await cacheServiceInstance.unset(key: 'tmp');
    //
    // String hello = await cacheServiceInstance.get(key: 'hello');
    // print(hello);
  }
}
