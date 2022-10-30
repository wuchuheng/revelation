import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/errors/not_login_error.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../service/global_service.dart';

enum SyncStatus { DOWNLOAD, DOWNLOADED, UPLOAD, UPLOADED }

class CacheService {
  final GlobalService _globalService;
  CacheService({required GlobalService globalService}) : _globalService = globalService;

  Hook<SyncStatus> syncStatus = Hook(SyncStatus.DOWNLOADED);

  ImapCacheService? _cacheServiceInstance;
  ImapCacheService getImapCache() {
    if (_cacheServiceInstance == null) throw NotLoginError();
    return _cacheServiceInstance!;
  }

  late Unsubscribe unsubscribeLog;
  late UnsubscribeCollect syncStatusSubscriptionCollect;
  bool isStartConnectListener = false;
  Hook<DateTime> lastSyncAtHook = Hook(DateTime.now());
  late ConnectConfig config;

  Future<ImapCacheService> connect({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
  }) async {
    Logger.info('Connect to IMAP.');
    isStartConnectListener = true;
    final directory = await getApplicationDocumentsDirectory();
    int syncIntervalSeconds = _globalService.generalService.syncIntervalHook.value;
    config = ConnectConfig(
      userName: userName,
      password: password,
      imapServerHost: imapServerHost,
      imapServerPort: imapServerPort,
      isImapServerSecure: isImapServerSecure,
      boxName: 'revelation',
      syncIntervalSeconds: syncIntervalSeconds,
      isDebug: Config.isDebug,
      localCacheDirectory: directory.path,
    );
    ImapCacheService cacheServiceInstance = await ImapCache().connectToServer(config);
    _cacheServiceInstance = cacheServiceInstance;

    ///  initialized data
    final imapCacheInstance = getImapCache();
    await Future.wait([
      _globalService.directoryService.init(),
      _globalService.chapterService.init(),
    ]);
    final unsubscribe = imapCacheInstance.subscribeLog((loggerItem) => _globalService.logService.push(loggerItem));
    final afterSyncUnsubscribe = imapCacheInstance.afterSync((duration) {
      _globalService.generalService.lastSyncTimeHook.set(DateTime.now());
      _globalService.generalService.setSyncState(false);
    });
    final imapCacheInstanceUnsubscribe = imapCacheInstance.beforeSync((loggerItem) {
      _globalService.generalService.setSyncState(true);
    });

    unsubscribeLog = Unsubscribe(() {
      unsubscribe.unsubscribe();
      afterSyncUnsubscribe.unsubscribe();
      imapCacheInstanceUnsubscribe.unsubscribe();
      _globalService.generalService.setSyncState(false);
      return true;
    });

    syncStatusSubscriptionCollect = UnsubscribeCollect([
      cacheServiceInstance.onDownloaded(() => syncStatus.set(SyncStatus.DOWNLOADED)),
      cacheServiceInstance.onDownload(() => syncStatus.set(SyncStatus.DOWNLOAD)),
      cacheServiceInstance.onUpdate(() => syncStatus.set(SyncStatus.UPLOAD)),
      cacheServiceInstance.onUpdated(() => syncStatus.set(SyncStatus.UPLOADED)),
      cacheServiceInstance.onDownloaded(() => lastSyncAtHook.set(DateTime.now())),
      cacheServiceInstance.onDownload(() => lastSyncAtHook.set(DateTime.now())),
      cacheServiceInstance.onUpdate(() => lastSyncAtHook.set(DateTime.now())),
      cacheServiceInstance.onUpdated(() => lastSyncAtHook.set(DateTime.now())),
      cacheServiceInstance.beforeSync((Duration duration) => lastSyncAtHook.set(DateTime.now())),
      cacheServiceInstance.afterSync((Duration duration) => lastSyncAtHook.set(DateTime.now())),
    ]);
    connectListener();
    return imapCacheInstance;
  }

  Future<void> disconnect() async {
    unsubscribeLog.unsubscribe();
    syncStatusSubscriptionCollect.unsubscribe();
    await getImapCache().disconnect();
    _globalService.chapterService.distroy();
    _globalService.directoryService.distroy();
    isStartConnectListener = false;
    connectListenerTimer?.cancel();
  }

  Timer? connectListenerTimer;

  /// 连接监听并尝试断网重连
  void connectListener() {
    connectListenerTimer?.cancel();
    connectListenerTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (lastSyncAtHook.value.microsecondsSinceEpoch + (config.syncIntervalSeconds + 20) * 1000000 <
          DateTime.now().microsecondsSinceEpoch) {
        Logger.error('Try to connect.');
        getImapCache().disconnect();
        await Future.delayed(const Duration(seconds: 1));
        connectListenerTimer?.cancel();
        lastSyncAtHook.set(DateTime.now());
        try {
          await connect(
            userName: config.userName,
            password: config.password,
            imapServerHost: config.imapServerHost,
            imapServerPort: config.imapServerPort,
            isImapServerSecure: config.isImapServerSecure,
          );
        } catch (_) {
          getImapCache().disconnect();
          connectListener();
        }
      }
      Logger.info('ConnectListener is running.');
      Logger.info('Last sync At: ${lastSyncAtHook.value.toString()}');
    });
  }
}
