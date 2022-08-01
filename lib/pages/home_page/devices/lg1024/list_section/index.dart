import 'package:flutter/material.dart';
import 'package:smtpnotes/pages/common_config.dart';

import './item_section.dart';

class ListSection extends StatefulWidget {
  const ListSection({Key? key}) : super(key: key);

  @override
  State<ListSection> createState() => _ListSectionState();
}

class _ListSectionState extends State<ListSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  Widget getContainer({required List<Widget> children}) {
    return Container(
        width: CommonConfig.lg1024ListWidth,
        height: MediaQuery.of(context).size.height - CommonConfig.toolBarHeight,
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          controller: _scrollController,
          mainAxisSpacing: 10,
          childAspectRatio: 3.5,
          crossAxisCount: 1,
          children: children,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return getContainer(children: [
      ItemSection(),
    ]);
  }
}
