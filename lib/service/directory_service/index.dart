import 'dart:async';
import 'dart:convert';

import 'package:snotes/dao/chapter_dao/index.dart';
import 'package:snotes/dao/directory_dao/index.dart';
import 'package:snotes/model/directory_model/index.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/service/directory_service/directory_service_util.dart';
import 'package:snotes/utils/hook_event/hook_event.dart';

class DirectoryService {
  static int rootNodeId = 0;
  static late Hook<DirectoryModel> activeNodeHook;

  /// The node  being modified.
  static Hook<DirectoryModel?> changedNodeHook = Hook(null);
  static Hook<DirectoryModel?> pointerNodeHook = Hook(null); // 右键点击的项
  static Hook<List<DirectoryModel>> directoryHook = Hook([]);

  static Future<void> init() async {
    activeNodeHook = Hook(DirectoryDao().has(id: 0)!);
    triggerUpdateDirectoryHook();
    CacheService.getImapCache().afterSetSubscribe(callback: _afterSetSubscription);
  }

  static void triggerUpdateDirectoryHook() {
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
      triggerUpdateDirectoryHook();
    }
  }

  /// convert data  from map to  directory data.
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

  /// create new node for directory.
  static create() async {
    final now = DateTime.now();
    final int id = now.microsecondsSinceEpoch;
    int pid = activeNodeHook.value.id;
    DirectoryModel newItem = DirectoryModel.create(
      id: id,
      pid: pid,
      sortNum: 0,
      title: 'New Folder',
      children: [],
    );
    await DirectoryServiceUtil.setLocalCache(newItem);
    activeNodeHook.set(newItem);
    changedNodeHook.set(newItem);
  }

  /// delete the node from the directory.
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

  static void setActiveNode(DirectoryModel result) {
    DirectoryService.activeNodeHook.set(result);
    final chapter = ChapterDao();
    final chapters = chapter.fetchByDirectoryId(result.id);
    ChapterService.setChapterList(chapters);
  }
}
