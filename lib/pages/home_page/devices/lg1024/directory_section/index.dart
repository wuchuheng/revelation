import 'package:flutter/material.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/create_button.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/item_section.dart';
import 'package:snotes/service/directory_tree_service/directory_tree_service.dart';

import '../../../../../model/tree_item_model/tree_item_model.dart';
import '../../../../../utils/subscription_builder/subscription_builder_abstract.dart';

class TreeSection extends StatefulWidget {
  const TreeSection({Key? key}) : super(key: key);

  @override
  State<TreeSection> createState() => _TreeSectionState();
}

class _TreeSectionState extends State<TreeSection> {
  List<TreeItemModel> treeItems = DirectoryTreeService.treeHook.value;
  late Unsubscribe treeSubscriptHandler;
  @override
  void initState() {
    super.initState();
    treeSubscriptHandler = DirectoryTreeService.treeHook.subscribe((data) => setState(() => treeItems = data));
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
    final list = Container(
      height: MediaQuery.of(context).size.height - bottomBarHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var treeItem in treeItems) ItemSection(key: ValueKey(treeItem.id), data: treeItem),
          ],
        ),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.green[100],
      width: CommonConfig.lg1024DirectoryWidth,
      padding: EdgeInsets.only(left: LRMargin, right: LRMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          list,
          CreateButton(bottomBarHeight: bottomBarHeight),
        ],
      ),
    );
  }
}
