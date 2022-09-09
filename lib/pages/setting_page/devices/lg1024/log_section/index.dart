import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:snotes/pages/setting_page/devices/lg1024/log_section/item_section.dart';
import 'package:snotes/service/log_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class LogSection extends StatefulWidget {
  const LogSection({Key? key}) : super(key: key);

  @override
  State<LogSection> createState() => _LogSectionState();
}

class _LogSectionState extends State<LogSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  ScrollController scrollController = ScrollController();
  int maxLogLength = 0;
  int calculationLogIndex = 0;

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      LogService.logHook.subscribe((value) {
        setState(() {
          final bottomPosition = scrollController.position.maxScrollExtent;
          final currentPosition = scrollController.position.pixels;
          final duration = bottomPosition - currentPosition;
          if (duration < 100) {
            scrollController.animateTo(
              bottomPosition,
              duration: Duration(
                milliseconds: duration ~/ 20,
              ),
              curve: Curves.linear,
            );
          }
          while (calculationLogIndex != value.length) {
            final log = value[calculationLogIndex];
            int logLength = log.type.name.length;
            logLength += log.message.length;
            logLength += log.symbol?.length ?? 0;
            logLength += log.file.length;
            if (maxLogLength < logLength) maxLogLength = logLength;
            calculationLogIndex++;
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
      width: maxLogLength.toDouble() * 8,
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
