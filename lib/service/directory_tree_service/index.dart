import 'dart:async';
import 'dart:convert';

import 'package:snotes/model/tree_item_model/tree_item_model.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:snotes/service/directory_tree_service/directory_local_cache.dart';
import 'package:snotes/service/directory_tree_service/sync_service.dart';
import 'package:snotes/utils/hook_event/hook_event.dart';

class DirectoryTreeService {
  static int rootNodeId = 0;
  static String key = 'path';
  static HookImp<TreeItemModel?> activeNodeHook = Hook.builder(null);

  /// 临时初始化一个暂时目录，用于在本地没有数据时，且线上还在同步数据到本地期间，临时使用
  static Map<String, TreeItemModel>? tmpLocalIdMapTreeItem;

  /// The node  being modified.
  static HookImp<TreeItemModel?> changedNodeHook = Hook.builder(null);
  static HookImp<TreeItemModel?> pointerNodeHook = Hook.builder(null); // 右键点击的项
  static HookImp<List<TreeItemModel>> treeHook = Hook.builder([]);

  static Future<void> init() async {
    final Map<String, TreeItemModel> localIdMapTreeItem = await DirectoryLocalCache.getLocalData(key: key);
    await _init(localIdMapTreeItem);
  }

  static Future<void> initForSync() async {
    final rootNode = TreeItemModel.createRootNode();
    final Map<String, TreeItemModel> localIdMapTreeItem = {TreeItemModel.rootNodeId.toString(): rootNode};
    tmpLocalIdMapTreeItem = localIdMapTreeItem;
    await _init(localIdMapTreeItem);
  }

  static Future<void> _init(Map<String, TreeItemModel> localIdMapTreeItem) async {
    final localTree = idMapTreeItemConvertToTree(localIdMapTreeItem);
    treeHook.set(localTree);
    final imapCache = CacheService.getImapCache();
    imapCache.beforeOnlineModifyLocalEvent(key: key, callback: _beforeSyncSubscription);
    imapCache.afterSetSubscribe(key: key, callback: _afterSetSubscription);
  }

  /// modify the directory tree when the local cache is modified.
  static void _afterSetSubscription(String value) async {
    final Map<String, TreeItemModel> localIdMapTreeItem = await DirectoryLocalCache.getLocalData(key: key);
    final localTree = idMapTreeItemConvertToTree(localIdMapTreeItem);
    treeHook.set(localTree);
  }

  static Future<String> _beforeSyncSubscription({required String onlineValue}) async {
    if (tmpLocalIdMapTreeItem != null) {
      tmpLocalIdMapTreeItem = null;
      return onlineValue;
    }

    Map<String, dynamic> onlineIdMapJson = jsonDecode(onlineValue);
    Map<String, TreeItemModel> localIdMapJson = await DirectoryLocalCache.getLocalData(key: key);
    Map<String, TreeItemModel> result = {};
    List<String> ids = localIdMapJson.keys.toList();
    for (String key in onlineIdMapJson.keys) {
      if (!ids.contains(key)) ids.add(key);
    }
    for (String key in ids) {
      TreeItemModel? node;
      node = null;
      node = SyncService.onlineSyncLocalWhileLocalExistAndOnlineExist(localIdMapJson, onlineIdMapJson, key);
      if (node != null) {
        result[key] = node;
        continue;
      }
      node = SyncService.onlineSyncLocalWhileLocalExistAndOnlineNone(localIdMapJson, onlineIdMapJson, key);
      if (node != null) {
        result[key] = node;
        continue;
      }
      node = SyncService.onlineSyncLocalWhileLocalNoneAndOnlineExist(localIdMapJson, onlineIdMapJson, key);
      if (node != null) {
        result[key] = node;
        continue;
      }
    }

    return onlineValue;
  }

  /// convert data  from map to  directory data.
  static List<TreeItemModel> idMapTreeItemConvertToTree(Map<String, TreeItemModel> pidMapTreeItem) {
    Map<int, TreeItemModel> idMapTreeItem = {};
    List<TreeItemModel> result = [];
    pidMapTreeItem.forEach(
      (key, value) {
        if (!value.isDelete) {
          idMapTreeItem[value.id] = value;
          if (value.pid == 0) {
            result.add(idMapTreeItem[value.id]!);
          } else if (idMapTreeItem.containsKey(value.pid)) {
            idMapTreeItem[value.pid]!.children.add(value);
          }
        }
      },
    );

    return result;
  }

  /// create new node for directory.
  static create() async {
    final now = DateTime.now();
    final int id = now.microsecondsSinceEpoch;
    int pid = activeNodeHook.value?.id ?? 0;
    TreeItemModel newItem = TreeItemModel.create(
      id: id,
      pid: pid,
      sortId: 0,
      isDelete: false,
      title: 'New Folder',
      count: 0,
      children: [],
    );
    Map<String, TreeItemModel> localTree = await DirectoryLocalCache.getLocalData(key: key);
    localTree[id.toString()] = newItem;
    await DirectoryLocalCache.setLocalTree(data: localTree, key: key);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
    activeNodeHook.set(newItem);

    /// TODO:Bug There must be a delay here to crate a new node before it wiill enter the input state.
    await Future.delayed(const Duration(seconds: 1));
    changedNodeHook.set(newItem);
  }

  /// delete the node from the directory.
  static delete(String id) async {
    Map<String, TreeItemModel> localTree = await DirectoryLocalCache.getLocalData(key: key);
    localTree[id]!.isDelete = true;
    await DirectoryLocalCache.setLocalTree(data: localTree, key: key);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
  }

  static Future<void> update(String nodeName) async {
    Map<String, TreeItemModel> localTree = await DirectoryLocalCache.getLocalData(key: key);
    String id = changedNodeHook.value!.id.toString();
    localTree[id]!.title = nodeName;
    await DirectoryLocalCache.setLocalTree(data: localTree, key: key);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
  }
}
