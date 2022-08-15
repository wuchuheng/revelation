import 'dart:convert';

import 'package:snotes/model/directory_model/index.dart';
import 'package:snotes/utils/date_time_util.dart';

/// Data synchronization processing
class SyncService {
  static DirectoryModel? onlineSyncLocalWhileLocalExistAndOnlineExist(
    Map<String, DirectoryModel> localIdMapJson,
    Map<String, dynamic> onlineIdMapJson,
    String key,
  ) {
    if (!onlineIdMapJson.containsKey(key) || !localIdMapJson.containsKey(key)) {
      return null;
    }
    final DirectoryModel localNode = localIdMapJson[key]!;
    final DirectoryModel onlineNode = jsonDecode(onlineIdMapJson[key]);
    DateTime localUpdatedAt = DateTimeUtil.convertTimeStr(localNode.updatedAt);
    DateTime onlineUpdatedAt = DateTimeUtil.convertTimeStr(onlineNode.updatedAt);

    if (onlineUpdatedAt.microsecondsSinceEpoch > localUpdatedAt.microsecondsSinceEpoch) {
      return onlineNode;
    }
    return null;
  }

  static DirectoryModel? onlineSyncLocalWhileLocalExistAndOnlineNone(
    Map<String, DirectoryModel> localIdMapJson,
    Map<String, dynamic> onlineIdMapJson,
    String key,
  ) {
    final isOk = localIdMapJson.containsKey(key) && !onlineIdMapJson.containsKey(key);
    if (!isOk) return null;
    DirectoryModel onlineNode = jsonDecode(onlineIdMapJson[key]);

    return onlineNode;
  }

  static DirectoryModel? onlineSyncLocalWhileLocalNoneAndOnlineExist(
    Map<String, DirectoryModel> localIdMapJson,
    Map<String, dynamic> onlineIdMapJson,
    String key,
  ) {
    final isOk = !localIdMapJson.containsKey(key) && onlineIdMapJson.containsKey(key);
    if (!isOk) return null;
    final DirectoryModel onlineNode = jsonDecode(onlineIdMapJson[key]);
    if (onlineNode.isDelete == false) {
      return onlineNode;
    }
    return null;
  }
}
