import 'dart:convert';

import 'package:snotes/model/tree_item_model/tree_item_model.dart';
import 'package:snotes/utils/date_time_util.dart';

/// Data synchronization processing
class SyncService {
  static TreeItemModel? onlineSyncLocalWhileLocalExistAndOnlineExist(
    Map<String, TreeItemModel> localIdMapJson,
    Map<String, dynamic> onlineIdMapJson,
    String key,
  ) {
    if (!onlineIdMapJson.containsKey(key) || !localIdMapJson.containsKey(key)) {
      return null;
    }
    final TreeItemModel localNode = localIdMapJson[key]!;
    final TreeItemModel onlineNode = jsonDecode(onlineIdMapJson[key]);
    DateTime localUpdatedAt = DateTimeUtil.convertTimeStr(localNode.updatedAt);
    DateTime onlineUpdatedAt = DateTimeUtil.convertTimeStr(onlineNode.updatedAt);

    if (onlineUpdatedAt.microsecondsSinceEpoch > localUpdatedAt.microsecondsSinceEpoch) {
      return onlineNode;
    }
    return null;
  }

  static TreeItemModel? onlineSyncLocalWhileLocalExistAndOnlineNone(
    Map<String, TreeItemModel> localIdMapJson,
    Map<String, dynamic> onlineIdMapJson,
    String key,
  ) {
    final isOk = localIdMapJson.containsKey(key) && !onlineIdMapJson.containsKey(key);
    if (!isOk) return null;
    TreeItemModel onlineNode = jsonDecode(onlineIdMapJson[key]);

    return onlineNode;
  }

  static TreeItemModel? onlineSyncLocalWhileLocalNoneAndOnlineExist(
    Map<String, TreeItemModel> localIdMapJson,
    Map<String, dynamic> onlineIdMapJson,
    String key,
  ) {
    final isOk = !localIdMapJson.containsKey(key) && onlineIdMapJson.containsKey(key);
    if (!isOk) return null;
    final TreeItemModel onlineNode = jsonDecode(onlineIdMapJson[key]);
    if (onlineNode.isDelete == false) {
      return onlineNode;
    }
    return null;
  }
}
