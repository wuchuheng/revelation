import 'dart:io';

import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snotes/model/directory_model/index.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/item_section/direct_icon_section.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/item_section/folder_icon_section.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/item_section/input_section.dart';
import 'package:snotes/service/directory_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

class ItemSection extends StatefulWidget {
  final DirectoryModel data;
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
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  bool _openContext = false;
  late bool isBorder;
  bool isActive = false;
  bool isChangeNode = false;

  @override
  void initState() {
    super.initState();
    final activeNode = DirectoryTreeService.activeNodeHook.value;
    final pointerTreeItem = DirectoryTreeService.pointerNodeHook.value;
    isBorder = activeNode?.id != pointerTreeItem?.id && widget.data.id == pointerTreeItem?.id;
    final activeTreeItem = DirectoryTreeService.activeNodeHook.value;
    isActive = activeTreeItem?.id == widget.data.id;
    unsubscribeCollect.addAll([
      DirectoryTreeService.activeNodeHook.subscribe(activeNodeSubscription),
      DirectoryTreeService.changedNodeHook.subscribe(changeNodeSubscription),
      DirectoryTreeService.pointerNodeHook.subscribe(pointerNodeSubscription),
    ]);
  }

  void changeNodeSubscription(DirectoryModel? data) {
    final result = data?.id == widget.data.id;
    if (result != isChangeNode) setState(() => isChangeNode = result);
  }

  void activeNodeSubscription(DirectoryModel? data) {
    final newResult = data?.id == widget.data.id;
    if (newResult != isActive) setState(() => isActive = newResult);
  }

  void pointerNodeSubscription(DirectoryModel? data) {
    final activeNode = DirectoryTreeService.activeNodeHook.value;
    final pointerTreeItem = DirectoryTreeService.pointerNodeHook.value;
    final newIsBorder = widget.data.id == pointerTreeItem?.id && widget.data.id != activeNode?.id;
    if (newIsBorder != isBorder) {
      setState(() => isBorder = newIsBorder);
    } else if (isBorder) {
      setState(() => isBorder = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  /// Click on the title event.
  void handleTap() {
    final value = DirectoryTreeService.activeNodeHook.value;
    DirectoryModel? result;
    if (value?.id != widget.data.id) result = widget.data;
    DirectoryTreeService.activeNodeHook.set(result);
    DirectoryTreeService.changedNodeHook.set(null);
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

  void handleRenameFolder() => DirectoryTreeService.changedNodeHook.set(widget.data);

  /// show the  context  menu.
  _showContext() async {
    final menu = await showContextMenu(
      menuItems: [
        ContextMenuItem(
          title: 'Rename Folder',
          onTap: handleRenameFolder,
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
      ],
    );
    menu?.onTap?.call();
  }

  /// 点击
  void handlePointerUp(PointerUpEvent event) {
    if (_openContext) {
      _showContext();
      _openContext = false;
      DirectoryTreeService.pointerNodeHook.set(null);
    }
  }

  /// 右击
  void handlePointerDown(PointerDownEvent e) {
    _openContext = e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton;
    if (_openContext) {
      DirectoryTreeService.pointerNodeHook.set(widget.data);
    } else {
      setState(() {});
    }
  }

  void handleSaveNodeName(String? value) {
    DirectoryTreeService.changedNodeHook.set(null);
  }

  void handleDoubleTapNode() {
    DirectoryTreeService.changedNodeHook.set(widget.data);
    DirectoryTreeService.activeNodeHook.set(widget.data);
  }

  Widget titleSection() {
    return Text(
      ' ${widget.data.title}',
      style: TextStyle(
        color: isActive ? Colors.white : Colors.black,
      ),
    );
  }

  Widget countSection() {
    return Text(
      '${widget.data.count}',
      style: TextStyle(
        color: isActive ? Colors.white : CommonConfig.textGrey,
      ),
    );
  }

  Widget nodeSection() {
    double padding = (10 * widget.level).toDouble();
    final activeTreeItem = DirectoryTreeService.activeNodeHook.value;

    return Listener(
        onPointerDown: handlePointerDown,
        onPointerUp: handlePointerUp,
        child: GestureDetector(
          onTap: handleTap,
          onDoubleTap: handleDoubleTapNode,
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
                    DirectIconSection(
                      isOpenFolder: isOpenFold,
                      onTap: () => setState(() => isOpenFold = !isOpenFold),
                      isNotEmpty: widget.data.children.isNotEmpty,
                    ),
                    FolderIconSection(isActive: isActive),
                    isChangeNode
                        ? InputSection(
                            onFieldSubmitted: handleSaveNodeName,
                            initialValue: activeTreeItem?.title,
                          )
                        : titleSection(),
                  ],
                ),
                countSection(),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        nodeSection(),
        if (isOpenFold)
          for (DirectoryModel item in widget.data.children)
            ItemSection(
              key: ValueKey(item.id),
              data: item,
              level: widget.level + 1,
            )
      ],
    );
  }
}
