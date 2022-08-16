import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/create_button.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/item_section/index.dart';
import 'package:snotes/service/directory_service/index.dart';

import '../../../../../model/directory_model/index.dart';
import '../../../../../utils/subscription_builder/subscription_builder_abstract.dart';

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
        Container(
          height: MediaQuery.of(context).size.height,
          color: Config.backgroundColor,
          width: Config.lg1024DirectoryWidth,
          padding: EdgeInsets.only(left: LRMargin, right: LRMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: Config.titleBarHeight)),
              list,
              const CreateButton(bottomBarHeight: bottomBarHeight),
            ],
          ),
        ),
      ],
    );
  }
}
