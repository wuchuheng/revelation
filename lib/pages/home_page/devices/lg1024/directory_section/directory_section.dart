import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/pages/home_page/devices/lg1024/directory_section/create_button.dart';
import 'package:revelation/pages/home_page/devices/lg1024/directory_section/item_section/item_section.dart';
import 'package:revelation/pages/home_page/devices/lg1024/directory_section/tool_bar_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../model/directory_model/directory_model.dart';

class TreeSection extends StatefulWidget {
  final GlobalService globalService;
  const TreeSection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<TreeSection> createState() => _TreeSectionState();
}

class _TreeSectionState extends State<TreeSection> {
  List<DirectoryModel> treeItems = [];
  late Unsubscribe treeSubscriptHandler;
  @override
  void initState() {
    treeItems = widget.globalService.directoryService.directoryHook.value;
    super.initState();
    treeSubscriptHandler = widget.globalService.directoryService.directoryHook.subscribe(
      (data, _) => setState(
        () => treeItems = data,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    treeSubscriptHandler.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget TreeSection', symbol: 'build');
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    double LRMargin = 10;
    const double bottomBarHeight = 40;
    final list = SizedBox(
      height: MediaQuery.of(context).size.height - bottomBarHeight - Config.titleBarHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var treeItem in treeItems)
              ItemSection(
                key: ValueKey(treeItem.id),
                data: treeItem,
                globalService: globalService,
              ),
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
