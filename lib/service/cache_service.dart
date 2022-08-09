import 'package:imap_cache/imap_cache.dart';
import 'package:snotes/errors/not_login_error.dart';

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
    required String boxName,
    int syncIntervalSeconds = 5,
    bool isShowLog = false,
  }) async {
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
    _cacheServiceInstance = cacheServiceInstance;

    ///  initialized data
    final imapCacheInstance = getImapCache();
    const String pathKey = 'path';
    if (!await imapCacheInstance.has(key: pathKey)) {
      // imapCacheInstance.set(key: key, value: value)

    }

    return imapCacheInstance;
  }

  static bool isLogin() => _cacheServiceInstance != null;
}
