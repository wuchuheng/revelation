import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/routes/route_path.dart';
import 'package:snotes/service/directory_service/index.dart';

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

  @override
  Widget build(BuildContext context) {
    const double padding = 10;
    final icon = Icon(Icons.arrow_back_ios, size: 15, color: Config.iconColor);
    final item = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapItem,
      child: Container(
          height: 35,
          padding: EdgeInsets.only(left: padding + 10.0 * widget.level, right: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(IconFont.icon_file_directory),
                  Container(child: Text(' ${widget.directory.title}'))
                ],
              ),
              SizedBox(
                  width: 31,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.directory.count}'),
                      widget.directory.children.isNotEmpty
                          ? GestureDetector(
                              onTap: onOpenFolder,
                              child: isOpen ? Transform.rotate(angle: pi * -0.5, child: icon) : icon,
                            )
                          : const Text(''),
                    ],
                  ))
            ],
          )),
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
