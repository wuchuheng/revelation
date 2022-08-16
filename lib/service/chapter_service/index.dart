import 'dart:convert';

import 'package:snotes/dao/chapter_dao/index.dart';
import 'package:snotes/model/directory_model/index.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:snotes/service/chapter_service/chapter_service_util.dart';
import 'package:snotes/service/directory_service/index.dart';
import 'package:snotes/utils/hook_event/hook_event.dart';

import '../../model/chapter_model/index.dart';

class ChapterService {
  static Hook<List<ChapterModel>> chapterListHook = Hook(ChapterDao().fetchAll());
  static Hook<ChapterModel?> editChapterHook = Hook(null);

  static Future<void> init() async {
    CacheService.getImapCache().afterSetSubscribe(callback: _afterSetSubscribe);
  }

  static void _afterSetSubscribe({required String key, required String value}) {
    if (ChapterServiceUtil.isChapterByCacheKey(key)) {
      Map<String, dynamic> jsonMapData = jsonDecode(value);
      ChapterModel chapter = ChapterModel.fromJson(jsonMapData);
      ChapterDao().save(chapter);
      _updateChapterHook();
    }
  }

  static void _updateChapterHook() {
    final List<ChapterModel> data = ChapterDao().fetchAll();
    chapterListHook.set(data);
  }

  static Future<void> create() async {
    final directoryId = DirectoryService.activeNodeHook.value?.id ?? DirectoryModel.rootNodeId;
    final id = DateTime.now().microsecondsSinceEpoch;
    ChapterModel chapter = ChapterModel(
      title: 'New Note',
      directoryId: directoryId,
      id: id,
      sortNum: 0,
      deletedAt: null,
      content: '''
--- 
title: New Note
createdAt: ${DateTime.now().toString()}
--- 

''',
      updatedAt: DateTime.now(),
    );
    await CacheService.getImapCache().set(
      key: ChapterServiceUtil.getCacheKeyById(chapter.id),
      value: jsonEncode(chapter),
    );
    editChapterHook.set(chapter);
    DirectoryService.triggerUpdateDirectoryHook();
  }

  static Future<void> update(ChapterModel chapter) async {
    await CacheService.getImapCache().set(
      key: ChapterServiceUtil.getCacheKeyById(chapter.id),
      value: jsonEncode(chapter),
    );
    chapterListHook.setCallback((data) {
      return data.map((e) {
        if (e.id == chapter.id) {
          e.content = chapter.content;
        }
        return e;
      }).toList();
    });
  }

  static void setEditChapter({required int id}) {
    final chapter = ChapterDao().has(id: id)!;
    editChapterHook.set(chapter);
  }

  static Future<void> delete(ChapterModel chapter) async {
    chapter.deletedAt = DateTime.now();
    await CacheService.getImapCache().set(
      key: ChapterServiceUtil.getCacheKeyById(chapter.id),
      value: jsonEncode(chapter),
    );
    DirectoryService.triggerUpdateDirectoryHook();
  }
}
