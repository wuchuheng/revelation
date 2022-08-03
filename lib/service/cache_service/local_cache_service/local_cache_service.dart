import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static SharedPreferences? _cacheInstance;
  static LocalCacheService? _instance;
  final String _hasLocalCacheSymbol = 'localCacheSymbol';

  static LocalCacheService getInstance() {
    LocalCacheService._instance ??= LocalCacheService();

    return LocalCacheService._instance!;
  }

  Future<void> initLocalCache() async {
    final cacheInstance = await _getCacheInstance();
    await cacheInstance.setBool(_hasLocalCacheSymbol, true);
  }

  static Future<SharedPreferences> _getCacheInstance() async {
    _cacheInstance ??= await SharedPreferences.getInstance();
    return _cacheInstance!;
  }

  Future<bool> hasLocalCache() async {
    final cacheInstance = await _getCacheInstance();
    final isLocalStore = cacheInstance.getBool(_hasLocalCacheSymbol);

    return isLocalStore != null && isLocalStore == true;
  }
}
