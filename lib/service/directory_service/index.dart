import 'dart:async';
import 'dart:convert';

import 'package:revelation/dao/directory_dao/index.dart';
import 'package:revelation/model/directory_model/index.dart';
import 'package:revelation/service/cache_service.dart';
import 'package:revelation/service/chapter_service/index.dart';
import 'package:revelation/service/directory_service/directory_service_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';

class DirectoryService {
  static int rootNodeId = 0;
  static Hook<DirectoryModel> activeNodeHook = Hook(DirectoryModel.getRootNodeInitData());

  /// The node  being modified.
  static Hook<DirectoryModel?> changedNodeHook = Hook(null);
  static Hook<DirectoryModel?> pointerNodeHook = Hook(null); // 右键点击的项
  static Hook<List<DirectoryModel>> directoryHook = Hook([]);
  static late Unsubscribe afterUnsubscription;

  static void distroy() {
    afterUnsubscription.unsubscribe();
  }

  static void setChangeNodeHook(DirectoryModel? value) => changedNodeHook.set(value);

  static Future<void> init() async {
    final rootNode = DirectoryDao().has(id: 0)!;
    activeNodeHook.set(rootNode);
    setActiveNode(rootNode);
    triggerUpdateDirectoryHook();
    afterUnsubscription = CacheService.getImapCache().afterSet(callback: _afterSetSubscription);
  }

  static void triggerUpdateDirectoryHook() {
    final directoryData = DirectoryDao().fetchAll();
    final directories = idMapTreeItemConvertToTree(directoryData);
    directoryHook.set(directories);
  }

  /// modify the directory_section tree when the local cache is modified.
  static Future<void> _afterSetSubscription({
    required String value,
    required String key,
    required String hash,
    required From from,
  }) async {
    if (DirectoryServiceUtil.isDirectoryByCacheKey(key)) {
      Map<String, dynamic> jsonMapData = jsonDecode(value);
      DirectoryModel directory = DirectoryModel.fromJson(jsonMapData);
      DirectoryDao().save(directory);
      triggerUpdateDirectoryHook();
    }
  }

  /// convert data  from map to  directory_section data.
  static List<DirectoryModel> idMapTreeItemConvertToTree(List<DirectoryModel> directories) {
    Map<int, DirectoryModel> idMapTreeItem = {};
    List<DirectoryModel> result = [];
    for (final value in directories) {
      if (value.deletedAt == null) {
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

  static String defaultTitle = 'New Folder';

  /// create new node for directory_section.
  static create([String? title]) async {
    final now = DateTime.now();
    final int id = now.microsecondsSinceEpoch;
    int pid = activeNodeHook.value.id;
    DirectoryModel newItem = DirectoryModel.create(
      id: id,
      pid: pid,
      sortNum: 0,
      title: title ?? defaultTitle,
      children: [],
    );
    await DirectoryServiceUtil.setLocalCache(newItem);
    activeNodeHook.set(newItem);
    changedNodeHook.set(newItem);
  }

  /// delete the node from the directory_section.
  static delete(String id) async {
    final directory = DirectoryDao().has(id: int.parse(id))!;
    directory.deletedAt = DateTime.now();
    await DirectoryServiceUtil.setLocalCache(directory);
  }

  static Future<void> update(String nodeName) async {
    final id = changedNodeHook.value!.id;
    final directory = DirectoryDao().has(id: id)!;
    directory.title = nodeName;
    await DirectoryServiceUtil.setLocalCache(directory);
    if (activeNodeHook.value.id == id) {
      activeNodeHook.setCallback((data) {
        data.title = nodeName;
        return data;
      });
    }
  }

  static void setActiveNode(DirectoryModel node) {
    DirectoryService.activeNodeHook.set(node);
    ChapterService.triggerUpdateChapterListHook();
  }
}
