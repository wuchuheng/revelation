import 'dart:convert';

import 'package:revelation/dao/chapter_dao/chapter_dao.dart';
import 'package:revelation/model/directory_model/directory_model.dart';
import 'package:revelation/service/chapter_service/chapter_service_util.dart';
import 'package:wuchuheng_helper/wuchuheng_helper.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';
import 'package:yaml/yaml.dart';

import '../../model/chapter_model/chapter_model.dart';
import '../global_service.dart';

class ChapterService {
  final GlobalService _globalService;

  ChapterService({required GlobalService globalService}) : _globalService = globalService;

  Hook<List<ChapterModel>> chapterListHook = Hook([]);
  Hook<ChapterModel?> editChapterHook = Hook(null);
  SubjectHook<void> onAnimationToTopSubject = SubjectHook();
  late Unsubscribe afterSetHandle;

  distroy() => afterSetHandle.unsubscribe();

  Future<void> init() async {
    chapterListHook.set(ChapterDao().fetchAll());
    afterSetHandle = _globalService.cacheService.getImapCache().afterSet(callback: _afterSetSubscribe);
  }

  Future<void> _afterSetSubscribe({
    required String key,
    required String value,
    required String hash,
    required From from,
  }) async {
    if (ChapterServiceUtil().isChapterByCacheKey(key)) {
      Map<String, dynamic> jsonMapData = jsonDecode(value);
      ChapterModel chapter = ChapterModel.fromJson(jsonMapData);
      final oldData = ChapterDao().has(id: chapter.id);
      ChapterDao().save(chapter);
      triggerUpdateChapterListHook();
      if (oldData == null || chapter.deletedAt != null) {
        _globalService.directoryService.triggerUpdateDirectoryHook();
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

  Future<void> create() async {
    final directoryId = _globalService.directoryService.activeNodeHook.value.id;
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
    await _globalService.cacheService.getImapCache().set(
          key: ChapterServiceUtil().getCacheKeyById(chapter.id),
          value: jsonEncode(chapter),
        );
    editChapterHook.set(chapter);
    _globalService.directoryService.triggerUpdateDirectoryHook();
    onAnimationToTopSubject.next(null);
  }

  setActiveEditChapter(ChapterModel chapter) {
    editChapterHook.set(chapter);
  }

  /// Set the chapter currently being edited
  Future<void> setEditChapter(ChapterModel chapter) async {
    editChapterHook.set(chapter);
    await _globalService.cacheService.getImapCache().set(
          key: ChapterServiceUtil().getCacheKeyById(chapter.id),
          value: jsonEncode(chapter),
        );
  }

  Future<void> delete(ChapterModel chapter) async {
    chapter.deletedAt = DateTime.now();
    await _globalService.cacheService.getImapCache().set(
          key: ChapterServiceUtil().getCacheKeyById(chapter.id),
          value: jsonEncode(chapter),
        );
    triggerUpdateChapterListHook();
    _globalService.directoryService.triggerUpdateDirectoryHook();
  }

  void triggerUpdateChapterListHook() {
    final nodeId = _globalService.directoryService.activeNodeHook.value.id;
    final isRootNode = DirectoryModel.rootNodeId == nodeId;
    final chapters = isRootNode ? ChapterDao().fetchAll() : ChapterDao().fetchByDirectoryId(nodeId);
    setChapterList(chapters);
  }

  void setChapterList(List<ChapterModel> chapters) {
    chapterListHook.set(chapters);
    final editChapter = _globalService.chapterService.editChapterHook.value;
    final activeNode = _globalService.directoryService.activeNodeHook.value;
    if (editChapter != null) {
      if (activeNode.id == DirectoryModel.rootNodeId) return;
      if (activeNode.id == editChapter.id) return;
      if (chapters.isNotEmpty) {
        if (activeNode.id != DirectoryModel.rootNodeId && activeNode.id != editChapter.directoryId) {
          _globalService.chapterService.editChapterHook.set(chapters[0]);
        }
      } else {
        _globalService.chapterService.editChapterHook.set(null);
      }
    } else {
      if (chapters.isNotEmpty) {
        _globalService.chapterService.editChapterHook.set(chapters[0]);
      }
    }
  }

  Function(ChapterModel value)? _debounce;
  onSave(ChapterModel value) {
    _debounce ??= Helper.debounce((ChapterModel newChapter) {
      final chapter = _globalService.chapterService.editChapterHook.value;
      if (chapter?.id == newChapter.id) {
        chapter!.content = newChapter.content;
        final regexp = RegExp(r'(?<=---)(.*?)(?=---)', multiLine: true, dotAll: true);
        final pregResult = regexp.firstMatch(chapter.content)?.group(0);
        if (pregResult != null) {
          var doc = loadYaml(pregResult) as Map;
          chapter.title = doc['title'].toString() ?? '';
        }
        chapter.updatedAt = DateTime.now();
        _globalService.chapterService.setEditChapter(chapter);
      }
    }, 1000);

    _debounce!(value);
  }
}
