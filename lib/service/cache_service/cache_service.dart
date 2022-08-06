import 'dart:async';

import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import 'package:snotes/service/cache_service/cache_service_abstract.dart';
import 'package:snotes/service/cache_service/imap_service/register_service.dart';
import 'package:snotes/service/cache_service/local_cache_service/local_cache_register_service.dart';
import 'package:snotes/service/cache_service/subscription/subscription.dart';
import 'package:snotes/service/cache_service/subscription/subscription_abstract.dart';
import 'package:snotes/service/cache_service/subscription/sync_event_subscription_abstract.dart';
import 'package:snotes/service/cache_service/sync_data.dart';
import 'package:snotes/service/cache_service/utils/logger.dart';
import 'package:snotes/service/cache_service/utils/single_task_pool.dart';

import 'local_cache_service/local_cache_service.dart';
import 'subscription/unsubscribe.dart'; // for the utf8.encode method

class CacheService implements CacheServiceAbstract, SubscriptionFactoryAbstract, SyncEventSubscriptionAbstract {
  static CacheService? _instance;
  final SingleTaskPool _limitSyncTaskPool = SingleTaskPool();
  bool _isSyncing = false;
  final Map<String, Map<int, void Function(String value)>> _setEventCallbackList = {};
  final Map<String, Map<int, void Function({required String key})>> _unsetEventCallbackList = {};
  final Map<int, void Function()> _completeSyncEventList = {};
  final Map<int, void Function()> _startSyncEventList = {};

  /// Synchronize online and local data
  Future<void> _syncOnline() async {
    Logger.info("Start synchronizing data");
    Future.wait([ _hookStartSyncEvent() ]);
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
      Future.wait([ _hookCompletedSyncEvent() ]);
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
    await LocalCacheService().set(key: key, value: value);
    Future.wait([ _hookSetEvents(key: key, value: value) ]);
  }
  Future<void> _hookSetEvents({required String key, required String value,}) async {
    if (_setEventCallbackList[key] != null && _setEventCallbackList[key]!.isNotEmpty) {
      for (final callback in _setEventCallbackList[key]!.values) {
        callback(value);
      }
    }
  }

  @override
  Future<void> unset({required String key}) async {
    LocalCacheService().unset(key: key);
    Future.wait([_hookUnsetEvents(key: key)]);
  }
  Future<void> _hookUnsetEvents({required String key}) async {
    if (_unsetEventCallbackList[key] != null && _unsetEventCallbackList[key]!.isNotEmpty) {
      for (final callback in _unsetEventCallbackList[key]!.values) {
        callback(key: key);
      }
    }
  }

  @override
  Future<String> get({required String key}) => LocalCacheService().get(key: key);

  @override
  Future<bool> has({required String key}) => LocalCacheService().has(key: key);

  @override
  UnsubscribeAbstract completedSyncEvent(void Function() callback) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _completeSyncEventList[id] = callback;
    return Unsubscription(() => _completeSyncEventList.remove(id));
  }
  Future<void> _hookCompletedSyncEvent() async {
    if (_completeSyncEventList.isNotEmpty) {
      _completeSyncEventList.forEach((_, value) => value());
    }
  }
  Future<void> _hookStartSyncEvent() async {
    if (_startSyncEventList.isNotEmpty) {
      _startSyncEventList.forEach((_, value) => value());
    }
  }

  @override
  UnsubscribeAbstract startSyncEvent(void Function() callback) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _startSyncEventList[id] = callback;
    return Unsubscription(() => _startSyncEventList.remove(id));
  }

  @override
  UnsubscribeAbstract setEventSubscribe({required String key, required void Function(String value) callback}) {
    int id = DateTime.now().microsecondsSinceEpoch;
    if (_setEventCallbackList[key] ==  null) _setEventCallbackList[key] = {};
    _setEventCallbackList[key]![id] = callback;
    return Unsubscription(() => _setEventCallbackList[key]!.remove(id));
  }

  @override
  UnsubscribeAbstract unsetEventSubscribe({required String key, required void Function({required String key}) callback}) {
    int id = DateTime.now().microsecondsSinceEpoch;
    if (_unsetEventCallbackList[key] ==  null)_unsetEventCallbackList[key] = {};
    _unsetEventCallbackList[key]![id] = callback;
    return Unsubscription(() =>_unsetEventCallbackList[key]!.remove(id));
  }
}
