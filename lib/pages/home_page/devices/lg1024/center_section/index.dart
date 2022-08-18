import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/pages/home_page/devices/lg1024/center_section/tool_bar/index.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/utils/logger.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

import 'empty_section.dart';
import 'item_section.dart';

class CenterSection extends StatefulWidget {
  const CenterSection({Key? key}) : super(key: key);

  @override
  State<CenterSection> createState() => _CenterSectionState();
}

class _CenterSectionState extends State<CenterSection> {
  late ScrollController _scrollController;
  List<ChapterModel> chapters = ChapterService.chapterListHook.value;
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    unsubscribeCollect.addAll([
      ChapterService.chapterListHook.subscribe((data) {
        setState(() => chapters = data.toList());
      }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  Widget getContainer({required List<Widget> children}) {
    final height = MediaQuery.of(context).size.height - Config.centerSectionToolBarHeight;
    final listSection = GridView.count(
      controller: _scrollController,
      // mainAxisSpacing: 10,
      childAspectRatio: 3.5,
      crossAxisCount: 1,
      children: children,
    );

    return Container(
      width: Config.lg1024CenterSectionWidth,
      height: height,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: Config.centerSectionItemGap),
      child: children.isEmpty ? const EmptySection() : listSection,
    );
  }

  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget CenterSection', symbol: 'build');
    return Container(
      width: Config.lg1024CenterSectionWidth,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Config.borderColor),
        ),
      ),
      child: Column(
        children: [
          const ToolBar(),
          getContainer(children: [
            for (int index = 0; index < chapters.length; index++)
              ItemSection(
                isFirst: true,
                key: Key(chapters[index].id.toString()),
                chapter: chapters[index],
              ),
          ]),
        ],
      ),
    );
  }
}
