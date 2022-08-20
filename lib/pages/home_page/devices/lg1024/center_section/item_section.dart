import 'dart:io';
import 'dart:ui';

import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../service/directory_service/index.dart';

class ItemSection extends StatefulWidget {
  final bool isFirst;
  final ChapterModel chapter;
  const ItemSection({super.key, required this.isFirst, required this.chapter});

  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  bool isActive = false;
  bool _openContext = false;
  late ChapterModel chapter;

  @override
  void initState() {
    chapter = widget.chapter;
    super.initState();
    isActive = ChapterService.editChapterHook.value?.id == widget.chapter.id;
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        final result = ChapterService.editChapterHook.value?.id == widget.chapter.id;
        bool isChange = false;
        if (result != isActive) {
          isChange = true;
          isActive = result;
        }
        if (widget.chapter.id == ChapterService.editChapterHook.value?.id) {
          isChange = true;
          chapter = ChapterService.editChapterHook.value!;
        }
        if (isChange) setState(() {});
      }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  void onDelete() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Note?', textAlign: TextAlign.center),
        content: const SizedBox(
          width: 300,
          child: Text(
            'Are you sure you want to delete this file?',
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ChapterService.delete(widget.chapter);
              Navigator.pop(context, 'OK');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// show the  context  menu.
  void _showContext() async {
    final menu = await showContextMenu(
      menuItems: [
        ContextMenuItem(
          title: 'Delete',
          onTap: onDelete,
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyN,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
      ],
    );
    menu?.onTap?.call();
  }

  /// 右击回弹
  void handlePointerUp(PointerUpEvent event) {
    if (_openContext) {
      _showContext();
      _openContext = false;
      DirectoryService.pointerNodeHook.set(null);
    }
  }

  /// 右击按下
  void handlePointerDown(PointerDownEvent e) {
    _openContext = e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton;
    if (_openContext) {
      // DirectoryService.pointerNodeHook.set(widget.data);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget ItemSection', symbol: 'build');
    const fontSize = 13.0;
    Color color = Colors.grey[600]!;
    final regexp = RegExp(r'---(.*?)---', multiLine: true, dotAll: true);
    String content = chapter.content;
    content = content.replaceAll(regexp, '');
    content = content.replaceAll(RegExp(r'^\s+\n', multiLine: true, dotAll: true), '');
    if (content.isNotEmpty) {
      content = content.split('\n')[0];
      const length = 10;
      content = content.length > length ? content.substring(0, length) : content;
    } else {
      content = '';
    }

    return Listener(
      onPointerDown: handlePointerDown,
      onPointerUp: handlePointerUp,
      child: GestureDetector(
        onTap: () => ChapterService.setEditChapter(chapter),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive ? Config.activeColor : Colors.grey[200],
          ),
          margin: EdgeInsets.only(
            left: Config.centerSectionItemGap,
            right: Config.centerSectionItemGap,
            top: widget.isFirst ? Config.centerSectionItemGap : 0,
          ),
          padding: const EdgeInsets.all(Config.centerSectionItemGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                chapter.title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${chapter.updatedAt.hour}:${chapter.updatedAt.minute}',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: isActive ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(' ${content.isNotEmpty ? content : "(No Date)"}',
                      style: TextStyle(
                        color: isActive ? Colors.white : color,
                        fontSize: fontSize,
                      ))
                ],
              ),
              Row(
                children: [
                  Icon(IconFont.icon_file_directory, size: fontSize, color: isActive ? Colors.white : color),
                  Text('  ${chapter.directory.title}',
                      style: TextStyle(fontSize: fontSize, color: isActive ? Colors.white : color)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
