import 'package:flutter/material.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/tab_section/header_section.dart';

class TabSection extends StatelessWidget {
  final List<TabItem> tabs;
  final int activeIndex;
  final Function(int activeIndeex) onChange;
  const TabSection(
      {Key? key,
      required this.tabs,
      required this.activeIndex,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowsHeight = MediaQuery.of(context).size.height;
    const double toolBarHeight = 60;
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: toolBarHeight,
          ),
          child: HeaderSection(
              tabs: tabs, activeIndex: activeIndex, onChange: onChange),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: windowsHeight - toolBarHeight,
          ),
          child: Center(
            child: tabs[activeIndex].body,
          ),
        ),
      ],
    );
  }
}
