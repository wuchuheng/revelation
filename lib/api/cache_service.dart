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

  Future<ImapCacheService> connect({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
  }) async {
    Logger.info('Connect to IMAP.');
    final directory = await getApplicationDocumentsDirectory();
    int syncIntervalSeconds = _globalService.generalService.syncIntervalHook.value;
    final config = ConnectConfig(
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
    ]);

    return imapCacheInstance;
  }

  Future<void> disconnect() async {
    unsubscribeLog.unsubscribe();
    syncStatusSubscriptionCollect.unsubscribe();
    await getImapCache().disconnect();
    _globalService.chapterService.distroy();
    _globalService.directoryService.distroy();
  }
}
