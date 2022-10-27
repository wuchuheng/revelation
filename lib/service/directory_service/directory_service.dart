import 'dart:async';
import 'dart:convert';

import 'package:revelation/dao/directory_dao/directory_dao.dart';
import 'package:revelation/model/directory_model/directory_model.dart';
import 'package:revelation/service/directory_service/directory_service_util.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';

class DirectoryService {
  late GlobalService _globalService;
  DirectoryService({required GlobalService globalService}) : _globalService = globalService;

  Hook<DirectoryModel> activeNodeHook = Hook(DirectoryModel.getRootNodeInitData());

  /// The node  being modified.
  Hook<DirectoryModel?> changedNodeHook = Hook(null);
  Hook<DirectoryModel?> pointerNodeHook = Hook(null); // 右键点击的项
  Hook<List<DirectoryModel>> directoryHook = Hook([]);
  late Unsubscribe afterUnsubscription;

  void distroy() {
    afterUnsubscription.unsubscribe();
  }

  void setChangeNodeHook(DirectoryModel? value) => changedNodeHook.set(value);

  Future<void> init() async {
    final rootNode = DirectoryDao().has(id: 0)!;
    activeNodeHook.set(rootNode);
    setActiveNode(rootNode);
    triggerUpdateDirectoryHook();
    afterUnsubscription = _globalService.cacheService.getImapCache().afterSet(callback: _afterSetSubscription);
  }

  void triggerUpdateDirectoryHook() {
    final directoryData = DirectoryDao().fetchAll();
    final directories = idMapTreeItemConvertToTree(directoryData);
    directoryHook.set(directories);
  }

  /// modify the directory_section tree when the local cache is modified.
  Future<void> _afterSetSubscription({
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
  List<DirectoryModel> idMapTreeItemConvertToTree(List<DirectoryModel> directories) {
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

  String defaultTitle = 'New Folder';

  /// create new node for directory_section.
  create([String? title]) async {
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
    await DirectoryServiceUtil.setLocalCache(newItem, _globalService.cacheService);
    activeNodeHook.set(newItem);
    changedNodeHook.set(newItem);
  }

  /// delete the node from the directory_section.
  delete(String id) async {
    final directory = DirectoryDao().has(id: int.parse(id))!;
    directory.deletedAt = DateTime.now();
    await DirectoryServiceUtil.setLocalCache(directory, _globalService.cacheService);
  }

  Future<void> update(String nodeName) async {
    final id = changedNodeHook.value!.id;
    final directory = DirectoryDao().has(id: id)!;
    directory.title = nodeName;
    await DirectoryServiceUtil.setLocalCache(directory, _globalService.cacheService);
    if (activeNodeHook.value.id == id) {
      activeNodeHook.setCallback((data) {
        data.title = nodeName;
        return data;
      });
    }
  }

  void setActiveNode(DirectoryModel node) {
    activeNodeHook.set(node);
    _globalService.chapterService.triggerUpdateChapterListHook();
  }
}
