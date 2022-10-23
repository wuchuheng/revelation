import 'dart:convert';

import 'package:revelation/dao/chapter_dao/index.dart';
import 'package:revelation/model/directory_model/index.dart';
import 'package:revelation/service/cache_service.dart';
import 'package:revelation/service/chapter_service/chapter_service_util.dart';
import 'package:revelation/service/directory_service/index.dart';
import 'package:wuchuheng_helper/wuchuheng_helper.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';
import 'package:yaml/yaml.dart';

import '../../model/chapter_model/index.dart';

class ChapterService {
  static Hook<List<ChapterModel>> chapterListHook = Hook([]);
  static Hook<ChapterModel?> editChapterHook = Hook(null);
  static SubjectHook<void> onAnimationToTopSubject = SubjectHook();
  static late Unsubscribe afterSetHandle;

  static distroy() => afterSetHandle.unsubscribe();

  static Future<void> init() async {
    chapterListHook.set(ChapterDao().fetchAll());
    afterSetHandle = CacheService.getImapCache().afterSet(callback: _afterSetSubscribe);
  }

  static Future<void> _afterSetSubscribe({
    required String key,
    required String value,
    required String hash,
    required From from,
  }) async {
    if (ChapterServiceUtil.isChapterByCacheKey(key)) {
      Map<String, dynamic> jsonMapData = jsonDecode(value);
      ChapterModel chapter = ChapterModel.fromJson(jsonMapData);
      final oldData = ChapterDao().has(id: chapter.id);
      ChapterDao().save(chapter);
      triggerUpdateChapterListHook();
      if (oldData == null || chapter.deletedAt != null) {
        DirectoryService.triggerUpdateDirectoryHook();
      }
      Logger.error("Value: " + chapter.title);

      if (chapter.id == editChapterHook.value?.id) {
        if (chapter.deletedAt != null) {
          editChapterHook.set(null);
        } else if (oldData != null &&
            chapter.content != oldData.content &&
            oldData.updatedAt.millisecondsSinceEpoch < chapter.updatedAt.millisecondsSinceEpoch) {
          editChapterHook.set(chapter);
        }
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
    onAnimationToTopSubject.next(null);
  }

  static Future<void> setActiveEditChapter(ChapterModel chapter) async => editChapterHook.set(chapter);

  /// Set the chapter currently being edited
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
    triggerUpdateChapterListHook();
    DirectoryService.triggerUpdateDirectoryHook();
  }

  static void triggerUpdateChapterListHook() {
    final nodeId = DirectoryService.activeNodeHook.value.id;
    final isRootNode = DirectoryModel.rootNodeId == nodeId;
    final chapters = isRootNode ? ChapterDao().fetchAll() : ChapterDao().fetchByDirectoryId(nodeId);
    setChapterList(chapters);
  }

  static void setChapterList(List<ChapterModel> chapters) {
    chapterListHook.set(chapters);
    final editChapter = ChapterService.editChapterHook.value;
    final activeNode = DirectoryService.activeNodeHook.value;
    if (editChapter != null) {
      if (activeNode.id == DirectoryModel.rootNodeId) return;
      if (activeNode.id == editChapter.id) return;
      if (chapters.isNotEmpty) {
        if (activeNode.id != DirectoryModel.rootNodeId && activeNode.id != editChapter.directoryId) {
          ChapterService.editChapterHook.set(chapters[0]);
        }
      } else {
        ChapterService.editChapterHook.set(null);
      }
    } else {
      if (chapters.isNotEmpty) {
        ChapterService.editChapterHook.set(chapters[0]);
      }
    }
  }

  static Function(ChapterModel value) onSave = Helper.debounce((ChapterModel newChapter) {
    final chapter = ChapterService.editChapterHook.value;
    if (chapter?.id == newChapter.id) {
      chapter!.content = newChapter.content;
      final regexp = RegExp(r'(?<=---)(.*?)(?=---)', multiLine: true, dotAll: true);
      final pregResult = regexp.firstMatch(chapter.content)?.group(0);
      if (pregResult != null) {
        var doc = loadYaml(pregResult) as Map;
        chapter.title = doc['title'].toString() ?? '';
      }
      chapter.updatedAt = DateTime.now();
      ChapterService.setEditChapter(chapter);
    }
  }, 1000);
}
