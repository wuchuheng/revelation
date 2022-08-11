import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:snotes/model/tree_item_model/tree_item_model.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/service/directory_tree_service/directory_tree_service.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

import '../../../../../common/iconfont.dart';

class ItemSection extends StatefulWidget {
  final TreeItemModel data;
  final int level;

  const ItemSection({
    super.key,
    required this.data,
    this.level = 0,
  });

  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  bool isOpenFold = true;
  ActiveTreeItem? activeTreeItem = DirectoryTreeService.activeTreeItemHook.data;
  late Unsubscrible activeTreeItemEvent;

  @override
  void initState() {
    super.initState();
    activeTreeItemEvent = DirectoryTreeService.activeTreeItemHook.subscribe(
      (data) => setState(() => activeTreeItem = data),
    );
  }

  @override
  void dispose() {
    super.dispose();
    activeTreeItemEvent.unsubscribe();
  }

  /// Click on the title event.
  void handleTap() {
    DirectoryTreeService.activeTreeItemHook.setCallback(
      (data) {
        final newData = ActiveTreeItem(treeItemModel: widget.data, isInput: false);
        if (data != null) {
          newData.isInput = data.treeItemModel.id == widget.data.id && data.isInput;
        }
        return newData;
      },
    );
  }

  Widget _getDirectIcon() {
    return GestureDetector(
      onTap: () => setState(() => isOpenFold = !isOpenFold),
      child: Container(
          width: 20,
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: widget.data.children.isNotEmpty
              ? Icon(
                  isOpenFold ? IconFont.icon_bottom : IconFont.icon_right,
                  size: 13,
                )
              : null),
    );
  }

  Widget _getItem() {
    double padding = (10 * widget.level).toDouble();
    bool isActive = activeTreeItem?.treeItemModel.id == widget.data.id;
    bool isInput = isActive && activeTreeItem?.isInput == true;

    return GestureDetector(
      onTap: handleTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isActive ? HexColor('##E4C65E') : null,
        ),
        margin: const EdgeInsets.only(top: 5),
        padding: EdgeInsets.only(left: padding, top: 5, bottom: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getDirectIcon(),
                Icon(
                  IconFont.icon_file_directory,
                  size: 17.5,
                  color: isActive ? Colors.white : Colors.black,
                ),
                isInput
                    ? Container(
                        height: 17.5,
                        width: 200,
                        margin: const EdgeInsets.only(left: 4),
                        child: TextField(
                          autofocus: true,
                          cursorColor: Colors.grey[700],
                          maxLines: 1,
                          style: const TextStyle(fontSize: 10),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 6),
                            hintText: 'Folder Name',
                          ),
                        ),
                      )
                    : Text(
                        ' ${widget.data.title}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black,
                        ),
                      ),
              ],
            ),
            Text(
              '${widget.data.count}',
              style: TextStyle(
                color: isActive ? Colors.white : CommonConfig.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getItem(),
        if (isOpenFold)
          for (TreeItemModel item in widget.data.children)
            ItemSection(
              key: ValueKey(item.id),
              data: item,
              level: widget.level + 1,
            )
      ],
    );
  }
}
