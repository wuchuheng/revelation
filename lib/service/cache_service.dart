import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/errors/not_login_error.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/service/log_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';

import 'directory_service/index.dart';

class CacheService {
  static Hook<bool> isConnectHook = Hook(false);
  static ImapCacheService? _cacheServiceInstance;
  static ImapCacheService getImapCache() {
    if (_cacheServiceInstance == null) throw NotLoginError();
    return _cacheServiceInstance!;
  }

  static late Unsubscribe unsubscribeLog;

  static Future<ImapCacheService> connect({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
    int syncIntervalSeconds = 5,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final config = ConnectConfig(
      userName: userName,
      password: password,
      imapServerHost: imapServerHost,
      imapServerPort: imapServerPort,
      isImapServerSecure: isImapServerSecure,
      boxName: 'snotes',
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
    unsubscribeLog = Unsubscribe(() {
      unsubscribe.unsubscribe();
      return true;
    });
    return imapCacheInstance;
  }

  static Future<void> disconnect() async {
    unsubscribeLog.unsubscribe();
    await getImapCache().disconnect();
  }
}
