import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/create_button.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/item_section/index.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/tool_bar_section.dart';
import 'package:snotes/service/directory_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../model/directory_model/index.dart';

class TreeSection extends StatefulWidget {
  const TreeSection({Key? key}) : super(key: key);

  @override
  State<TreeSection> createState() => _TreeSectionState();
}

class _TreeSectionState extends State<TreeSection> {
  List<DirectoryModel> treeItems = DirectoryService.directoryHook.value;
  late Unsubscribe treeSubscriptHandler;
  @override
  void initState() {
    super.initState();
    treeSubscriptHandler = DirectoryService.directoryHook.subscribe((data) => setState(() => treeItems = data));
  }

  @override
  void dispose() {
    super.dispose();
    treeSubscriptHandler.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget TreeSection', symbol: 'build');
    double LRMargin = 10;
    const double bottomBarHeight = 40;
    final list = SizedBox(
      height: MediaQuery.of(context).size.height - bottomBarHeight - Config.titleBarHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var treeItem in treeItems) ItemSection(key: ValueKey(treeItem.id), data: treeItem),
          ],
        ),
      ),
    );

    return Column(
      children: [
        const ToolBarSection(),
        Container(
          decoration: BoxDecoration(
            color: Config.backgroundColor,
            border: Border(
              right: BorderSide(
                width: 1,
                color: Config.borderColor,
              ),
            ),
          ),
          height: MediaQuery.of(context).size.height - Config.titleBarHeight,
          width: Config.lg1024DirectoryWidth,
          padding: EdgeInsets.only(left: LRMargin, right: LRMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Padding(padding: EdgeInsets.only(top: Config.titleBarHeight)),
              list,
              const CreateButton(bottomBarHeight: bottomBarHeight),
            ],
          ),
        ),
      ],
    );
  }
}
