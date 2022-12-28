import 'dart:convert';

import 'package:revelation/dao/chapter_dao/chapter_dao.dart';
import 'package:revelation/dao/directory_dao/directory_dao.dart';
import 'package:revelation/model/directory_model/directory_model.dart';
import 'package:revelation/service/chapter_service/chapter_service_util.dart';
import 'package:uuid/uuid.dart';
import 'package:wuchuheng_helper/wuchuheng_helper.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_imap_cache/wuchuheng_imap_cache.dart';

import '../../model/chapter_model/chapter_model.dart';
import '../global_service.dart';

class ChapterService {
  final GlobalService _globalService;

  ChapterService({required GlobalService globalService}) : _globalService = globalService;

  Hook<List<ChapterModel>> chapterListHook = Hook([]);
  Hook<ChapterModel?> editChapterHook = Hook(null);
  SubjectHook<void> onAnimationToTopSubject = SubjectHook();
  Hook<bool> isPreviewHook = Hook<bool>(false);
  late Unsubscribe unsubscribe;

  distroy() {
    unsubscribe.unsubscribe();
  }

  void setIsPreview(bool value) => isPreviewHook.set(value);

  Future<void> init() async {
    final chapters = ChapterDao().fetchAll();
    List<ChapterModel> fullDataChapters = chapters
        .where(
          (chapter) => DirectoryDao().has(id: chapter.directoryId) != null,
        )
        .toList();

    chapterListHook.set(fullDataChapters);
    unsubscribe = _globalService.cacheService.getImapCache().afterSet(callback: _afterSetSubscribe);
  }

  Map<int, List<Function()>> directoryIdMapTask = {};

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
      void task() {
        triggerUpdateChapterListHook();
        if (oldData == null || chapter.deletedAt != null) {
          _globalService.directoryService.triggerUpdateDirectoryHook();
        }

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

      if (DirectoryDao().has(id: chapter.directoryId) == null) {
        _globalService.directoryService.updatedDirectorySubject.subscribe((value, cancel) {
          if (value.id == chapter.directoryId) {
            task();
            cancel();
          }
        });
      } else {
        task();
      }
    }
  }

  Future<void> create() async {
    final directoryId = _globalService.directoryService.activeNodeHook.value.id;
    final id = DateTime.now().microsecondsSinceEpoch;
    const uuid = Uuid();

    ChapterModel chapter = ChapterModel(
      title: 'New Note',
      directoryId: directoryId,
      uuid: uuid.v4(),
      id: id,
      sortNum: 0,
      deletedAt: null,
      content: '',
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
    final fullDataChapters = chapters.where((chapter) => DirectoryDao().has(id: chapter.directoryId) != null).toList();

    setChapterList(fullDataChapters);
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
    _debounce ??= debounce((ChapterModel value) async {
      final chapter = _globalService.chapterService.editChapterHook.value;
      if (chapter?.id == value.id) {
        chapter!.content = value.content;
        chapter.updatedAt = DateTime.now();
        chapter.title = value.title;
        _globalService.chapterService.setEditChapter(chapter);
        await _globalService.cacheService.getImapCache().set(
              key: ChapterServiceUtil().getCacheKeyById(chapter.id),
              value: jsonEncode(chapter),
            );
      }
    }, 500);

    _debounce!(value);
  }
}
