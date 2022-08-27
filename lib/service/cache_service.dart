import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/errors/not_login_error.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';

import 'directory_service/index.dart';

class CacheService {
  static Hook<bool> isConnectHook = Hook(false);

  static ImapCacheServiceAbstract? _cacheServiceInstance;
  static ImapCacheServiceAbstract getImapCache() {
    if (_cacheServiceInstance == null) throw NotLoginError();
    return _cacheServiceInstance!;
  }

  static Future<ImapCacheServiceAbstract> login({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
    int syncIntervalSeconds = 5,
    bool isDebug = Config.isDebug,
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
      isDebug: isDebug,
      localCacheDirectory: directory.path,
    );
    ImapCacheServiceAbstract cacheServiceInstance = await ImapCache().connectToServer(config);
    CacheService._cacheServiceInstance = cacheServiceInstance;

    ///  initialized data
    final imapCacheInstance = getImapCache();
    await Future.wait([
      DirectoryService.init(),
      ChapterService.init(),
    ]);
    isConnectHook.set(true);
    return imapCacheInstance;
  }
}
