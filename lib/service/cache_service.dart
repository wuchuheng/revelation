import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/errors/not_login_error.dart';
import 'package:revelation/service/chapter_service/index.dart';
import 'package:revelation/service/general_service/index.dart';
import 'package:revelation/service/log_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';

import 'directory_service/index.dart';

enum SyncStatus { DOWNLOAD, DOWNLOADED, UPLOAD, UPLOADED }

class CacheService {
  static Hook<bool> isConnectHook = Hook(false);
  static Hook<SyncStatus> syncStatus = Hook(SyncStatus.DOWNLOADED);

  static ImapCacheService? _cacheServiceInstance;
  static ImapCacheService getImapCache() {
    if (_cacheServiceInstance == null) throw NotLoginError();
    return _cacheServiceInstance!;
  }

  static late Unsubscribe unsubscribeLog;
  static late UnsubscribeCollect syncStatusSubscriptionCollect;

  static Future<ImapCacheService> connect({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    int syncIntervalSeconds = GeneralService.syncIntervalHook.value;
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
    CacheService._cacheServiceInstance = cacheServiceInstance;

    ///  initialized data
    final imapCacheInstance = getImapCache();
    await Future.wait([
      DirectoryService.init(),
      ChapterService.init(),
    ]);
    isConnectHook.set(true);
    final unsubscribe = imapCacheInstance.subscribeLog((loggerItem) => LogService.push(loggerItem));
    final afterSyncUnsubscribe = imapCacheInstance.afterSync((duration) {
      GeneralService.lastSyncTimeHook.set(DateTime.now());
      GeneralService.setSyncState(false);
    });
    final imapCacheInstanceUnsubscribe = imapCacheInstance.beforeSync((loggerItem) {
      GeneralService.setSyncState(true);
    });

    unsubscribeLog = Unsubscribe(() {
      unsubscribe.unsubscribe();
      afterSyncUnsubscribe.unsubscribe();
      imapCacheInstanceUnsubscribe.unsubscribe();
      GeneralService.setSyncState(false);
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

  static Future<void> disconnect() async {
    unsubscribeLog.unsubscribe();
    syncStatusSubscriptionCollect.unsubscribe();
    await getImapCache().disconnect();
    ChapterService.distroy();
    DirectoryService.distroy();
  }
}
