import 'package:flutter/material.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/center_section/tool_bar/index.dart';

import './item_section.dart';

class CenterSection extends StatefulWidget {
  const CenterSection({Key? key}) : super(key: key);

  @override
  State<CenterSection> createState() => _CenterSectionState();
}

class _CenterSectionState extends State<CenterSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  Widget getContainer({required List<Widget> children}) {
    final height = MediaQuery.of(context).size.height - CommonConfig.centerSectionToolBarHeight;
    return Container(
      width: CommonConfig.lg1024CenterSectionWidth,
      height: height,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: CommonConfig.centerSectionItemGap),
      child: GridView.count(
        controller: _scrollController,
        mainAxisSpacing: 10,
        childAspectRatio: 3.5,
        crossAxisCount: 1,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CommonConfig.lg1024CenterSectionWidth,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: CommonConfig.borderColor),
        ),
      ),
      child: Column(
        children: [
          const ToolBar(),
          getContainer(children: [
            const ItemSection(
              isFirst: true,
            ),
            const ItemSection(),
            const ItemSection(),
            const ItemSection(),
            const ItemSection(),
            const ItemSection(),
            const ItemSection(),
            const ItemSection(),
            const ItemSection(),
          ]),
        ],
      ),
    );
  }
}
