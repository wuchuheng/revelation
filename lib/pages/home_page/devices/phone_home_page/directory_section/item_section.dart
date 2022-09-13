import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final item = Container(
        height: 35,
        padding: EdgeInsets.only(left: 5 + 10.0 * widget.level, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(IconFont.icon_file_directory),
                Text(' ${widget.directory.title}'),
              ],
            ),
            const Icon(Icons.arrow_left),
          ],
        ));
    return Column(
      children: [
        item,
        ...widget.directory.children.map((e) => ItemSection(directory: e, level: widget.level + 1)).toList(),
      ],
    );
  }
}
