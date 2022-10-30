import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/pages/home_page/devices/lg1024/center_section/tool_bar/tool_bar.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'empty_section.dart';
import 'item_section.dart';

class CenterSection extends StatefulWidget {
  final GlobalService globalService;
  const CenterSection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<CenterSection> createState() => _CenterSectionState();
}

class _CenterSectionState extends State<CenterSection> {
  late ScrollController _scrollController;
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    unsubscribeCollect.addAll([
      widget.globalService.chapterService.chapterListHook.subscribe((data, _) {
        setState(() {});
      }),
      widget.globalService.chapterService.onAnimationToTopSubject.subscribe((value, _) {
        final pixels = _scrollController.position.pixels ~/ 3;
        final duration = Duration(milliseconds: pixels);
        _scrollController.animateTo(0, duration: duration, curve: Curves.linear);
      })
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
      childAspectRatio: 3.8,
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
    Logger.info('Build widget CenterSection', symbol: 'build');
    final GlobalService globalService = RepositoryProvider.of(context);
    final chapters = globalService.chapterService.chapterListHook.value;

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
          ToolBar(globalService: RepositoryProvider.of<GlobalService>(context)),
          getContainer(children: [
            for (int index = 0; index < chapters.length; index++)
              ItemSection(
                globalService: globalService,
                isFirst: true,
                key: Key(chapters[index].id.toString() + chapters[index].updatedAt.toString()),
                chapter: chapters[index],
              ),
          ]),
        ],
      ),
    );
  }
}
