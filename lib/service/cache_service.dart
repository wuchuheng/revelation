import 'package:imap_cache/imap_cache.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/errors/not_login_error.dart';
import 'package:snotes/service/chapter_service/index.dart';

import 'directory_service/index.dart';

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
    bool isShowLog = Config.isDebug,
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
    await Future.wait([
      DirectoryService.init(),
      ChapterService.init(),
    ]);

    return imapCacheInstance;
  }

  static bool isLogin() => CacheService._cacheServiceInstance != null;
}
