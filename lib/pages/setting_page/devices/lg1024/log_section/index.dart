import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/log_section/item_section.dart';
import 'package:revelation/service/log_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class LogSection extends StatefulWidget {
  const LogSection({Key? key}) : super(key: key);

  @override
  State<LogSection> createState() => _LogSectionState();
}

class _LogSectionState extends State<LogSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      LogService.logHook.subscribe((value) {
        setState(() {
          final bottomPosition = scrollController.position.maxScrollExtent;
          final currentPosition = scrollController.position.pixels;
          final duration = bottomPosition - currentPosition;
          if (duration < 100 && duration > 0) {
            scrollController.animateTo(
              bottomPosition,
              duration: Duration(
                milliseconds: duration ~/ 20,
              ),
              curve: Curves.linear,
            );
          }
        });
      }),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = LogService.logHook.value;
    final item = Container(
      padding: const EdgeInsets.all(10),
      height: double.infinity,
      width: LogService.maxLogLength.toDouble() * 8,
      child: ListView.builder(
          controller: scrollController,
          itemCount: logs.length,
          itemBuilder: (context, index) => ItemSection(log: logs[index])),
    );

    return AdaptiveScrollbar(
      controller: ScrollController(),
      width: double.infinity,
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.horizontal,
        child: item,
      ),
    );
  }
}
