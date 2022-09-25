import 'dart:math';

import 'package:flutter/material.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/chapter_service/index.dart';
import 'package:revelation/service/directory_service/index.dart';
import 'package:wuchuheng_ui/wuchuheng_ui.dart';

import '../../../../../common/iconfont.dart';
import '../../../../../model/directory_model/index.dart';

class ItemSection extends StatefulWidget {
  final DirectoryModel directory;
  final int level;
  const ItemSection({Key? key, required this.directory, this.level = 0}) : super(key: key);

  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  bool isOpen = false;
  onOpenFolder() {
    setState(() => isOpen = !isOpen);
    return;
  }

  onTapItem() {
    DirectoryService.setActiveNode(widget.directory);
    RoutePath.pushChapterListPage();
  }

  onDelete() {
    DirectoryService.delete(widget.directory.id.toString());
  }

  onRename(String newName) {
    DirectoryService.setChangeNodeHook(widget.directory);
    DirectoryService.update(newName);
  }

  void onCreateChapter() async {
    DirectoryService.setActiveNode(widget.directory);
    await ChapterService.create();
    RoutePath.pushChapterDetailPage();
  }

  void onCreateNode(BuildContext context) {
    onConfirmDialog(
      initValue: DirectoryService.defaultTitle,
      context: context,
      title: 'Create Node',
      validator: (String? value) {
        if (value != null && value == '') {
          return 'Node must be not empty.';
        }
        return null;
      },
      onConfirm: (value) {
        DirectoryService.setActiveNode(widget.directory);
        DirectoryService.create(value);
        if (!isOpen) setState(() => isOpen = true);
      },
    );
  }

  void showMenu(BuildContext context) {
    const renameKey = 'rename';
    const deleteKey = 'delete';
    const createChapterKey = 'create chapter';
    const createNodeKey = 'create node';
    final items = <BottomSheetItem>[
      BottomSheetItem(title: 'Create Node', key: createNodeKey),
      BottomSheetItem(title: 'Create Chapter', key: createChapterKey),
      if (DirectoryService.rootNodeId != widget.directory.id) BottomSheetItem(title: 'Rename', key: renameKey),
      if (DirectoryService.rootNodeId != widget.directory.id)
        BottomSheetItem(title: 'Delete', color: Colors.red, key: deleteKey),
    ];
    onBottomSheet(
      onTap: (String key) {
        switch (key) {
          case renameKey:
            onConfirmDialog(
              initValue: widget.directory.title,
              validator: (String? value) {
                if (value != null && value == '') {
                  return 'Node must be not empty!';
                }
                return null;
              },
              onConfirm: (value) => onRename(value),
              context: context,
              title: 'Rename Node',
            );
            break;
          case deleteKey:
            onDialog(context: context, title: 'Delete Node', describe: 'Are you sure?', onConfirm: onDelete);
            break;
          case createChapterKey:
            onCreateChapter();
            break;
          case createNodeKey:
            onCreateNode(context);
            break;
        }
      },
      context: context,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 10;
    final icon = Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Icon(Icons.arrow_back_ios, size: 19, color: Config.iconColor),
    );
    const iconWrapperWidth = 43.0;
    final item = Container(
      height: 43,
      padding: EdgeInsets.only(left: padding + 10.0 * widget.level, right: padding),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onLongPress: () => showMenu(context),
              behavior: HitTestBehavior.opaque,
              onTap: onTapItem,
              child: SizedBox(
                width: constraints.maxWidth - iconWrapperWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [const Icon(IconFont.icon_file_directory), Text(' ${widget.directory.title}')]),
                    Text('${widget.directory.count}'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.directory.children.isNotEmpty ? onOpenFolder() : null,
              child: SizedBox(
                width: iconWrapperWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.directory.children.isNotEmpty
                        ? SizedBox(child: isOpen ? Transform.rotate(angle: pi * -0.5, child: icon) : icon)
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );

    return Column(
      children: [
        item,
        if (isOpen)
          ...widget.directory.children.map((e) => ItemSection(directory: e, level: widget.level + 1)).toList(),
      ],
    );
  }
}
