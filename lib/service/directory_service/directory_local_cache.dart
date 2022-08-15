import 'dart:async';
import 'dart:convert';

import 'package:imap_cache/imap_cache.dart';
import 'package:task_util/task_util.dart';

import '../../model/directory_model/index.dart';
import '../cache_service.dart';

class DirectoryLocalCache {
  static SingleTaskPool singleTaskPool = SingleTaskPool.builder();

  static Future<Map<String, DirectoryModel>> getLocalData({required String key}) async {
    Completer<Map<String, DirectoryModel>> completer = Completer();
    singleTaskPool.start(() async {
      ImapCache cacheService = CacheService.getImapCache();
      Map<String, DirectoryModel> localIdMapTreeItem = {};
      if (!await cacheService.has(key: key)) {
        final rootNode = DirectoryModel.getRootNodeInitData();
        localIdMapTreeItem[DirectoryModel.rootNodeId.toString()] = rootNode;
        await cacheService.set(key: key, value: jsonEncode(localIdMapTreeItem));
      } else {
        Map<String, dynamic> jsonMapData = jsonDecode(
          await cacheService.get(key: key),
        );
        jsonMapData.forEach((key, value) {
          localIdMapTreeItem[key] = DirectoryModel.fromJson(value as Map<String, dynamic>);
        });
      }

      completer.complete(localIdMapTreeItem);
    });

    return completer.future;
  }

  /// save data locally.
  static Future<void> setLocalTree({
    required Map<String, DirectoryModel> data,
    required String key,
  }) async {
    await singleTaskPool.start(() async {
      ImapCache cacheService = CacheService.getImapCache();
      cacheService.set(key: key, value: jsonEncode(data));
    });
  }
}
