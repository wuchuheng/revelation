import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late Unsubscrible activeTreeItemEvent;
  late Unsubscrible pointerTreeItemEvent;
  bool _openContext = false;
  late bool isBorder;

  @override
  void initState() {
    super.initState();
    final activeTreeItem = DirectoryTreeService.activeTreeItemHook.data;
    final pointerTreeItem = DirectoryTreeService.pointerTreeItemHook.data;
    isBorder = activeTreeItem?.treeItemModel.id != pointerTreeItem?.id && widget.data.id == pointerTreeItem?.id;
    activeTreeItemEvent = DirectoryTreeService.activeTreeItemHook.subscribe((data) => setState(() {}));
    pointerTreeItemEvent = DirectoryTreeService.pointerTreeItemHook.subscribe((data) {
      final activeTreeItem = DirectoryTreeService.activeTreeItemHook.data;
      final pointerTreeItem = DirectoryTreeService.pointerTreeItemHook.data;
      final newIsBorder = widget.data.id == pointerTreeItem?.id && widget.data.id != activeTreeItem?.treeItemModel.id;
      if (newIsBorder != isBorder) {
        setState(() => isBorder = newIsBorder);
      } else if (isBorder) {
        setState(() => isBorder = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    activeTreeItemEvent.unsubscribe();
    pointerTreeItemEvent.unsubscribe();
  }

  /// Click on the title event.
  void handleTap() {
    DirectoryTreeService.activeTreeItemHook.setCallback((data) {
      final newData = ActiveTreeItem(treeItemModel: widget.data, isInput: false);
      if (data != null) {
        newData.isInput = data.treeItemModel.id == widget.data.id && data.isInput;
      }
      return newData;
    });
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

  /// the  dialog for delete the node
  void handleDeleteDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Folder?', textAlign: TextAlign.center),
        content: const SizedBox(
          width: 300,
          child: Text(
            'Deleting this  Folder  won\'t affect its notes, which will remain in  their folders.',
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
            onPressed: () {
              DirectoryTreeService.delete(widget.data.id.toString());
              Navigator.pop(context, 'OK');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// show the  context  menu.
  _showContext() async {
    final _menu = await showContextMenu(
      menuItems: [
        ContextMenuItem(
          title: '新建',
          onTap: () {},
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyN,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
        const ContextMenuSeparator(),
        ContextMenuItem(
          title: 'Delete Folder',
          onTap: handleDeleteDialog,
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyC,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
        ContextMenuItem(
          title: '粘贴',
          onTap: () {
            BotToast.showText(text: '你按了粘贴');
          },
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
      ],
    );
    _menu?.onTap?.call();
  }

  /// 点击
  void handlePointerUp(PointerUpEvent event) {
    if (_openContext) {
      _showContext();
      _openContext = false;
      DirectoryTreeService.pointerTreeItemHook.set(null);
    }
  }

  /// 右击
  void handlePointerDown(PointerDownEvent e) {
    _openContext = e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton;
    if (_openContext) {
      DirectoryTreeService.pointerTreeItemHook.set(widget.data);
    } else {
      setState(() {});
    }
  }

  Widget _getItem() {
    double padding = (10 * widget.level).toDouble();
    final activeTreeItem = DirectoryTreeService.activeTreeItemHook.data;
    bool isActive = activeTreeItem?.treeItemModel.id == widget.data.id;
    bool isInput = isActive && activeTreeItem?.isInput == true;

    return Listener(
        onPointerDown: handlePointerDown,
        onPointerUp: handlePointerUp,
        child: GestureDetector(
          onTap: handleTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: isActive ? CommonConfig.activeColor : null,
              border: isBorder
                  ? Border.all(color: CommonConfig.activeBorderColor)
                  : Border.all(color: CommonConfig.backgroundColor),
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
        ));
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
