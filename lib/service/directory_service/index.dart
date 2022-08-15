import 'dart:async';
import 'dart:convert';

import 'package:snotes/dao/directory_dao/index.dart';
import 'package:snotes/model/directory_model/index.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:snotes/service/directory_service/directory_service_util.dart';
import 'package:snotes/utils/hook_event/hook_event.dart';

class DirectoryTreeService {
  static int rootNodeId = 0;
  static HookImp<DirectoryModel?> activeNodeHook = Hook.builder(null);

  /// The node  being modified.
  static HookImp<DirectoryModel?> changedNodeHook = Hook.builder(null);
  static HookImp<DirectoryModel?> pointerNodeHook = Hook.builder(null); // 右键点击的项
  static HookImp<List<DirectoryModel>> directoryHook = Hook.builder([]);

  static Future<void> init() async {
    _updateDirectoryHook();
    CacheService.getImapCache().afterSetSubscribe(callback: _afterSetSubscription);
  }

  static void _updateDirectoryHook() {
    final directoryData = DirectoryDao().fetchAll();
    final directories = idMapTreeItemConvertToTree(directoryData);
    directoryHook.set(directories);
  }

  /// modify the directory tree when the local cache is modified.
  static void _afterSetSubscription({required String value, required String key}) async {
    if (DirectoryServiceUtil.isDirectoryByCacheKey(key)) {
      Map<String, dynamic> jsonMapData = jsonDecode(value);
      DirectoryModel directory = DirectoryModel.fromJson(jsonMapData);
      DirectoryDao().save(directory);
      _updateDirectoryHook();
    }
  }

  /// convert data  from map to  directory data.
  static List<DirectoryModel> idMapTreeItemConvertToTree(List<DirectoryModel> directories) {
    Map<int, DirectoryModel> idMapTreeItem = {};
    List<DirectoryModel> result = [];
    for (final value in directories) {
      if (!value.isDelete) {
        idMapTreeItem[value.id] = value;
        if (value.pid == 0) {
          result.add(idMapTreeItem[value.id]!);
        } else if (idMapTreeItem.containsKey(value.pid)) {
          idMapTreeItem[value.pid]!.children.add(value);
        }
      }
    }

    return result;
  }

  /// create new node for directory.
  static create() async {
    final now = DateTime.now();
    final int id = now.microsecondsSinceEpoch;
    int pid = activeNodeHook.value?.id ?? 0;
    DirectoryModel newItem = DirectoryModel.create(
      id: id,
      pid: pid,
      sortId: 0,
      isDelete: false,
      title: 'New Folder',
      count: 0,
      children: [],
    );
    await DirectoryServiceUtil.setLocalCache(newItem);
    activeNodeHook.set(newItem);
    changedNodeHook.set(newItem);
  }

  /// delete the node from the directory.
  static delete(String id) async {
    final directory = DirectoryDao().has(id: int.parse(id))!;
    directory.isDelete = true;
    await DirectoryServiceUtil.setLocalCache(directory);
  }

  static Future<void> update(String nodeName) async {
    String id = changedNodeHook.value!.id.toString();
    final directory = DirectoryDao().has(id: int.parse(id))!;
    directory.title = nodeName;
    await DirectoryServiceUtil.setLocalCache(directory);
  }
}
