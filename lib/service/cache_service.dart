import 'package:imap_cache/imap_cache.dart';
import 'package:snotes/errors/not_login_error.dart';

import 'directory_tree_service/directory_tree_service.dart';

class CacheService {
  static ImapCache? _cacheServiceInstance;

  static ImapCache getImapCache() {
    if (_cacheServiceInstance == null) throw NotLoginError();
    return _cacheServiceInstance!;
  }

  static Future<ImapCache> login({
    required String userName,
    required String password,
    required String imapServerHost,
    required int imapServerPort,
    required bool isImapServerSecure,
    int syncIntervalSeconds = 5,
    bool isShowLog = true,
  }) async {
    const String boxName = 'snotes';
    ImapCache cacheServiceInstance = await ImapCache().connectToServer(
      userName: userName,
      password: password,
      imapServerHost: imapServerHost,
      imapServerPort: imapServerPort,
      isImapServerSecure: isImapServerSecure,
      boxName: boxName,
      syncIntervalSeconds: syncIntervalSeconds,
      isShowLog: isShowLog,
    );
    CacheService._cacheServiceInstance = cacheServiceInstance;

    ///  initialized data
    final imapCacheInstance = getImapCache();

    DirectoryTreeService.init();
    return imapCacheInstance;
  }

  static bool isLogin() => CacheService._cacheServiceInstance != null;
}
