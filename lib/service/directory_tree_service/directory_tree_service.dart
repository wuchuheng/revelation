import 'dart:convert';

import 'package:imap_cache/imap_cache.dart';
import 'package:snotes/model/tree_item_model/tree_item_model.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:snotes/utils/hook_event/hook_event.dart';

class ActiveTreeItem {
  TreeItemModel treeItemModel;
  bool isInput;

  ActiveTreeItem({required this.treeItemModel, required this.isInput});
}

class DirectoryTreeService {
  static String key = 'path';
  static Hook<ActiveTreeItem?> activeTreeItemHook = HookEvent.builder(null);
  static Hook<List<TreeItemModel>> treeHook = HookEvent.builder([]);

  static Future<void> init() async {
    final localIdMapTreeItem = await _getLocalTree();
    final localTree = idMapTreeItemConvertToTree(localIdMapTreeItem);
    treeHook.set(localTree);
  }

  static Future<Map<String, TreeItemModel>> _getLocalTree() async {
    ImapCache cacheService = CacheService.getImapCache();
    if (!await cacheService.has(key: key)) {
      await cacheService.set(key: key, value: '{}');
    }
    Map<String, dynamic> jsonMapData = jsonDecode(
      await cacheService.get(key: key),
    );
    Map<String, TreeItemModel> localIdMapTreeItem = {};
    jsonMapData.forEach((key, value) {
      localIdMapTreeItem[key] = TreeItemModel.fromJson(value as Map<String, dynamic>);
    });

    return localIdMapTreeItem;
  }

  static Future<void> _setLocalTree(Map<String, TreeItemModel> data) async {
    ImapCache cacheService = CacheService.getImapCache();
    cacheService.set(key: key, value: jsonEncode(data));
  }

  static List<TreeItemModel> idMapTreeItemConvertToTree(Map<String, TreeItemModel> pidMapTreeItem) {
    Map<int, TreeItemModel> idMapTreeItem = {};
    List<TreeItemModel> result = [];
    pidMapTreeItem.forEach(
      (key, value) {
        if (!value.isDelete) {
          idMapTreeItem[value.id] = value;
          if (value.pid == 0) {
            result.add(idMapTreeItem[value.id]!);
          } else {
            idMapTreeItem[value.pid]!.children.add(value);
          }
        }
      },
    );

    return result;
  }

  static create() async {
    final now = DateTime.now();
    final int id = now.microsecondsSinceEpoch;
    int pid = activeTreeItemHook.data?.treeItemModel.id ?? 0;
    TreeItemModel newItem = TreeItemModel(
      id: id,
      pid: pid,
      updatedAt: now.toString(),
      sortId: 0,
      isDelete: false,
      title: 'New Folder',
      count: 0,
      children: [],
    );
    Map<String, TreeItemModel> localTree = await _getLocalTree();
    localTree[id.toString()] = newItem;
    await _setLocalTree(localTree);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
    await Future.delayed(const Duration(seconds: 1));
    activeTreeItemHook.setCallback((data) => ActiveTreeItem(treeItemModel: newItem, isInput: true));
  }
}
