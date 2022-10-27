import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/pages/home_page/devices/lg1024/directory_section/item_section/node_section/title_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../../config/config.dart';
import 'count_section.dart';
import 'direct_icon_section.dart';
import 'folder_icon_section.dart';
import 'input_section.dart';

class NodeSectionState extends StatelessWidget {
  final int level;
  final bool isActive;
  final bool isBorder;
  final bool isOpenFold;
  final bool childrenIsNotEmpty;
  final bool isChangeNode;
  final String title;
  final int count;
  final void Function(bool newIsFolder) onChangeIsFolder;
  final void Function(PointerDownEvent e) handlePointerDown;
  final void Function(String? value) handleSaveNodeName;
  final void Function(PointerUpEvent e) handlePointerUp;
  final void Function() handleTap;

  const NodeSectionState({
    super.key,
    required this.level,
    required this.handlePointerDown,
    required this.handlePointerUp,
    required this.handleTap,
    required this.isActive,
    required this.isBorder,
    required this.isOpenFold,
    required this.onChangeIsFolder,
    required this.childrenIsNotEmpty,
    required this.isChangeNode,
    required this.handleSaveNodeName,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget NodeSectionState', symbol: 'build');
    double padding = (8 * level).toDouble();
    final activeTreeItem = RepositoryProvider.of<GlobalService>(context).directoryService.activeNodeHook.value;

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DirectIconSection(
              isOpenFolder: isOpenFold,
              onTap: () => onChangeIsFolder(!isOpenFold),
              isNotEmpty: childrenIsNotEmpty,
            ),
            FolderIconSection(isActive: isActive),
            isChangeNode
                ? InputSection(
                    onFieldSubmitted: handleSaveNodeName,
                    initialValue: activeTreeItem.title,
                  )
                : TitleSection(title: title, isActive: isActive)
          ],
        ),
        CountSection(count: count, isActive: isActive),
      ],
    );
    return Listener(
      onPointerDown: handlePointerDown,
      onPointerUp: handlePointerUp,
      child: GestureDetector(
        onTap: handleTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: isActive ? Config.activeColor : null,
            border: isBorder ? Border.all(color: Config.activeBorderColor) : Border.all(color: Config.backgroundColor),
          ),
          padding: EdgeInsets.only(left: padding, top: 5, bottom: 5, right: 5),
          child: child,
        ),
      ),
    );
  }
}
