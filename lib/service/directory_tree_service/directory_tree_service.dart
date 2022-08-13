import 'dart:async';
import 'dart:convert';

import 'package:imap_cache/imap_cache.dart';
import 'package:snotes/model/tree_item_model/tree_item_model.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:snotes/utils/hook_event/hook_event.dart';
import 'package:task_util/task_util.dart';

class DirectoryTreeService {
  static String key = 'path';
  static HookImp<TreeItemModel?> activeNodeHook = Hook.builder(null);

  /// The node  being modified.
  static HookImp<TreeItemModel?> changedNodeHook = Hook.builder(null);
  static HookImp<TreeItemModel?> pointerTreeItemHook = Hook.builder(null); // 右键点击的项
  static HookImp<List<TreeItemModel>> treeHook = Hook.builder([]);
  static SingleTaskPool singleTaskPool = SingleTaskPool.builder();

  static Future<void> init() async {
    final localIdMapTreeItem = await _getLocalData();
    final localTree = idMapTreeItemConvertToTree(localIdMapTreeItem);
    treeHook.set(localTree);
  }

  static Future<Map<String, TreeItemModel>> _getLocalData() async {
    Completer<Map<String, TreeItemModel>> completer = Completer();
    singleTaskPool.start(() async {
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

      completer.complete(localIdMapTreeItem);
    });

    return completer.future;
  }

  /// save data locally.
  static Future<void> _setLocalTree(Map<String, TreeItemModel> data) async {
    await singleTaskPool.start(() async {
      ImapCache cacheService = CacheService.getImapCache();
      cacheService.set(key: key, value: jsonEncode(data));
    });
  }

  /// convert data  in map form to  directory data.
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
    Map<String, TreeItemModel> localTree = await _getLocalData();
    localTree[id.toString()] = newItem;
    await _setLocalTree(localTree);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
    activeNodeHook.set(newItem);
    changedNodeHook.set(newItem);
  }

  /// delete the node from the directory.
  static delete(String id) async {
    Map<String, TreeItemModel> localTree = await _getLocalData();
    localTree[id]!.isDelete = true;
    await _setLocalTree(localTree);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
  }

  static Future<void> update(String nodeName) async {
    Map<String, TreeItemModel> localTree = await _getLocalData();
    String id = changedNodeHook.value!.id.toString();
    localTree[id]!.title = nodeName;
    await _setLocalTree(localTree);
    final List<TreeItemModel> newTree = idMapTreeItemConvertToTree(localTree);
    treeHook.set(newTree);
  }
}
