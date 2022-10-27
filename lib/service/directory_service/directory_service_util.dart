import 'dart:convert';

import 'package:revelation/model/directory_model/directory_model.dart';

import '../../api/cache_service.dart';

class DirectoryServiceUtil {
  static const String _cachePrefix = 'directory_item_data';
  static String getCacheKeyById(int id) {
    return '${_cachePrefix}_$id';
  }

  static bool isDirectoryByCacheKey(String key) {
    if (key.length < _cachePrefix.length) {
      return false;
    }
    return key.substring(0, _cachePrefix.length) == _cachePrefix;
  }

  static Future<void> setLocalCache(DirectoryModel directory, CacheService cacheService) async {
    await cacheService.getImapCache().set(
          key: DirectoryServiceUtil.getCacheKeyById(directory.id),
          value: jsonEncode(directory),
        );
  }
}
