import 'dart:convert';

import 'package:snotes/dao/chapter_dao/index.dart';
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
      final oldData = ChapterDao().has(id: chapter.id);
      ChapterDao().save(chapter);
      if (oldData == null) {
        final List<ChapterModel> data = ChapterDao().fetchAll();
        setChapterList(data);
      }
    }
  }

  static Future<void> create() async {
    final directoryId = DirectoryService.activeNodeHook.value.id;
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

  static Future<void> setEditChapter(ChapterModel chapter) async {
    editChapterHook.set(chapter);
    await CacheService.getImapCache().set(
      key: ChapterServiceUtil.getCacheKeyById(chapter.id),
      value: jsonEncode(chapter),
    );
  }

  static Future<void> delete(ChapterModel chapter) async {
    chapter.deletedAt = DateTime.now();
    await CacheService.getImapCache().set(
      key: ChapterServiceUtil.getCacheKeyById(chapter.id),
      value: jsonEncode(chapter),
    );
    DirectoryService.triggerUpdateDirectoryHook();
  }

  static void setChapterList(List<ChapterModel> chapters) {
    chapterListHook.set(chapters);
    final editChapter = ChapterService.editChapterHook.value;
    final activeNode = DirectoryService.activeNodeHook.value;

    if (editChapter?.directoryId != activeNode.id && chapters.isNotEmpty) {
      ChapterService.editChapterHook.set(chapters[0]);
    } else if (editChapter?.directoryId != activeNode.id) {
      ChapterService.editChapterHook.set(null);
    }
  }
}
