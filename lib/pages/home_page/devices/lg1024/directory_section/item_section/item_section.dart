import 'dart:io';

import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/model/directory_model/directory_model.dart';
import 'package:revelation/pages/home_page/devices/lg1024/directory_section/item_section/node_section/node_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class ItemSection extends StatefulWidget {
  final DirectoryModel data;
  final int level;
  final GlobalService globalService;

  const ItemSection({
    super.key,
    required this.data,
    this.level = 0,
    required this.globalService,
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
    final activeNode = widget.globalService.directoryService.activeNodeHook.value;
    final pointerTreeItem = widget.globalService.directoryService.pointerNodeHook.value;
    isBorder = activeNode.id != pointerTreeItem?.id && widget.data.id == pointerTreeItem?.id;
    final activeTreeItem = widget.globalService.directoryService.activeNodeHook.value;
    isActive = activeTreeItem.id == widget.data.id;
    unsubscribeCollect.addAll([
      widget.globalService.directoryService.activeNodeHook.subscribe(activeNodeSubscription),
      widget.globalService.directoryService.changedNodeHook.subscribe(changeNodeSubscription),
      widget.globalService.directoryService.pointerNodeHook.subscribe(pointerNodeSubscription),
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
    final activeNode = widget.globalService.directoryService.activeNodeHook.value;
    final pointerTreeItem = widget.globalService.directoryService.pointerNodeHook.value;
    final newIsBorder = widget.data.id == pointerTreeItem?.id && widget.data.id != activeNode.id;
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

  DateTime _lastClickedAt = DateTime.now();

  /// Click on the title event.
  void handleTap() {
    widget.globalService.directoryService.setActiveNode(widget.data);
    // doubleTap
    if (DateTime.now().microsecondsSinceEpoch - _lastClickedAt.microsecondsSinceEpoch < 500000) {
      widget.globalService.directoryService.changedNodeHook.set(widget.data);
    } else {
      widget.globalService.directoryService.changedNodeHook.set(null);
    }
    _lastClickedAt = DateTime.now();
  }

  /// the  on_dialog for delete the node
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
              widget.globalService.directoryService.delete(widget.data.id.toString());
              Navigator.pop(context, 'OK');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void handleRenameFolder() => widget.globalService.directoryService.changedNodeHook.set(widget.data);

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
          onTap: DirectoryModel.rootNodeId != widget.data.id ? handleDeleteDialog : null,
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
      widget.globalService.directoryService.pointerNodeHook.set(null);
    }
  }

  /// 右击
  void handlePointerDown(PointerDownEvent e) {
    _openContext = e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton;
    if (_openContext) {
      widget.globalService.directoryService.pointerNodeHook.set(widget.data);
    } else {
      setState(() {});
    }
  }

  void handleSaveNodeName(String? value) => widget.globalService.directoryService.changedNodeHook.set(null);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget ItemSection', symbol: 'build');
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);

    return Column(
      children: [
        NodeSectionState(
          level: widget.level,
          handlePointerDown: handlePointerDown,
          handlePointerUp: handlePointerUp,
          handleTap: handleTap,
          isActive: isActive,
          isBorder: isBorder,
          isOpenFold: isOpenFold,
          onChangeIsFolder: (_) => setState(() => isOpenFold = !isOpenFold),
          childrenIsNotEmpty: widget.data.children.isNotEmpty,
          isChangeNode: isChangeNode,
          handleSaveNodeName: handleSaveNodeName,
          title: widget.data.title,
          count: widget.data.count,
        ),
        if (isOpenFold)
          for (DirectoryModel item in widget.data.children)
            ItemSection(
              globalService: globalService,
              key: ValueKey(item.id),
              data: item,
              level: widget.level + 1,
            )
      ],
    );
  }
}
