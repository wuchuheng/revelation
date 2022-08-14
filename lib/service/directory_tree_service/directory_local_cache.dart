import 'dart:async';
import 'dart:convert';

import 'package:imap_cache/imap_cache.dart';
import 'package:task_util/task_util.dart';

import '../../model/tree_item_model/tree_item_model.dart';
import '../cache_service.dart';

class DirectoryLocalCache {
  static SingleTaskPool singleTaskPool = SingleTaskPool.builder();

  static Future<Map<String, TreeItemModel>> getLocalData({required String key}) async {
    Completer<Map<String, TreeItemModel>> completer = Completer();
    singleTaskPool.start(() async {
      ImapCache cacheService = CacheService.getImapCache();
      Map<String, TreeItemModel> localIdMapTreeItem = {};
      if (!await cacheService.has(key: key)) {
        final rootNode = TreeItemModel.createRootNode();
        localIdMapTreeItem[TreeItemModel.rootNodeId.toString()] = rootNode;
        await cacheService.set(key: key, value: jsonEncode(localIdMapTreeItem));
      } else {
        Map<String, dynamic> jsonMapData = jsonDecode(
          await cacheService.get(key: key),
        );
        jsonMapData.forEach((key, value) {
          localIdMapTreeItem[key] = TreeItemModel.fromJson(value as Map<String, dynamic>);
        });
      }

      completer.complete(localIdMapTreeItem);
    });

    return completer.future;
  }

  /// save data locally.
  static Future<void> setLocalTree({
    required Map<String, TreeItemModel> data,
    required String key,
  }) async {
    await singleTaskPool.start(() async {
      ImapCache cacheService = CacheService.getImapCache();
      cacheService.set(key: key, value: jsonEncode(data));
    });
  }
}
