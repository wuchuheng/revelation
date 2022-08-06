import 'dart:async';

import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import 'package:snotes/service/cache_service/cache_service_abstract.dart';
import 'package:snotes/service/cache_service/imap_service/register_service.dart';
import 'package:snotes/service/cache_service/local_cache_service/local_cache_register_service.dart';
import 'package:snotes/service/cache_service/sync_data.dart';
import 'package:snotes/service/cache_service/utils/logger.dart';
import 'package:snotes/service/cache_service/utils/single_task_pool.dart';

import 'local_cache_service/local_cache_service.dart'; // for the utf8.encode method

class CacheService implements CacheServiceAbstract {
  static CacheService? _instance;
  static final SingleTaskPool _limitSyncTaskPool = SingleTaskPool();
  static bool _isSyncing = false;

  /// Synchronize online and local data
  Future<void> _syncOnline() async {
    Logger.info("Start synchronizing data");
    try {
      // init onlineData
      RegisterService registerService = RegisterService();
      RegisterInfo? hasRegisterInfo = await registerService.hasRegister();
      if (hasRegisterInfo == null) {
        final RegisterInfo initData = RegisterInfo(uidMapKey: {}, data: {});
        await registerService.setRegister(data: initData);
        hasRegisterInfo = initData;
      }
      RegisterInfo onlineRegister = hasRegisterInfo;
      RegisterInfo localRegister = await LocalCacheRegisterService().getRegister();
      List<String> onlineKeys = onlineRegister.data.keys.toList();
      List<String> localKeys = localRegister.data.keys.toList();
      List<String> allKeys = onlineKeys;
      for (String e in localKeys) {
        if (!onlineKeys.contains(e)) onlineKeys.add(e);
      }
      for (String key in allKeys) {
        await SyncData.onlineExistAndLocalNone(
          onlineRegisterInfo: onlineRegister,
          localRegisterInfo: localRegister,
          key: key,
        );
        await SyncData.onlineExistAndLocalExist(
            onlineRegisterInfo: onlineRegister,
            localRegisterInfo: localRegister,
            key: key);
        await SyncData.onlineNoneAndLocalExist(
            onlineRegisterInfo: onlineRegister,
            localRegisterInfo: localRegister,
            key: key);
      }
      Logger.info('Completed data synchronization.');
    } catch (e) {
      print(e);
    }
    await Future.delayed(const Duration(seconds: 10));
    _syncOnline().then((value) => null);
    Logger.info("Synchronization of completed data");
  }

  /// connect to the IMAP server with user's account
  Future<void> connectToServer() async {
    await _limitSyncTaskPool.start(() async {
      if (!_isSyncing) {
        _isSyncing = true;
        _syncOnline().then((value) => null);
      }
    });
  }

  static Future<CacheService> getInstance() async {
    _instance ??= CacheService();

    return _instance!;
  }

  @override
  Future<void> set({
    required String key,
    required String value,
  }) async {
    connectToServer();
    await Future.wait([
      LocalCacheService().set(key: key, value: value),
      // ImapService.getInstance().set(key: key, value: value),
    ]);
  }

  @override
  Future<void> unset({required String key}) async {
    await Future.wait([
      LocalCacheService().unset(key: key),
      // ImapService.getInstance().unset(key: key),
    ]);
  }

  @override
  Future<String> get({required String key}) async {
    return await LocalCacheService().get(key: key);
  }

  @override
  Future<bool> has({required String key}) async {
    return await LocalCacheService().has(key: key);
    // return await ImapService.getInstance().has(key: key);
  }

  /// todo sync event
}
