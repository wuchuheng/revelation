import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_ui/wuchuheng_ui.dart';

import '../../../../../common/iconfont.dart';
import '../../../../../model/directory_model/directory_model.dart';

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

  onTapItem(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    globalService.directoryService.setActiveNode(widget.directory);
    pushChapterListPage(context);
  }

  onDelete(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    globalService.directoryService.delete(widget.directory.id.toString());
  }

  onRename(String newName, BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    globalService.directoryService.setChangeNodeHook(widget.directory);
    globalService.directoryService.update(newName);
  }

  void onCreateChapter(BuildContext context) async {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    globalService.directoryService.setActiveNode(widget.directory);
    await globalService.chapterService.create();
    pushChapterDetailPage(context);
  }

  void onCreateNode(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    onConfirmDialog(
      initValue: globalService.directoryService.defaultTitle,
      context: context,
      title: 'Create Node',
      validator: (String? value) {
        if (value != null && value == '') {
          return 'Node must be not empty.';
        }
        return null;
      },
      onConfirm: (value) {
        globalService.directoryService.setActiveNode(widget.directory);
        globalService.directoryService.create(value);
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
      BottomSheetItem(title: createNodeKey, key: createNodeKey),
      BottomSheetItem(title: createChapterKey, key: createChapterKey),
      if (DirectoryModel.rootNodeId != widget.directory.id) BottomSheetItem(title: renameKey, key: renameKey),
      if (DirectoryModel.rootNodeId != widget.directory.id)
        BottomSheetItem(title: deleteKey, color: Colors.red, key: deleteKey),
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
              onConfirm: (value) => onRename(value, context),
              context: context,
              title: 'Rename Node',
            );
            break;
          case deleteKey:
            onDialog(
              context: context,
              title: 'Delete Node',
              describe: 'Are you sure?',
              onConfirm: () => onDelete(context),
            );
            break;
          case createChapterKey:
            onCreateChapter(context);
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
    const double height = 43;
    final item = Container(
      height: height,
      padding: EdgeInsets.only(left: padding + 10.0 * widget.level, right: padding),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onLongPress: () => showMenu(context),
              behavior: HitTestBehavior.opaque,
              onTap: () => onTapItem(context),
              child: SizedBox(
                height: height,
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
