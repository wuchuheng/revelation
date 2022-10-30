import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/log_section/item_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../../../../service/log_service/log_service.dart';

class LogSection extends StatefulWidget {
  final GlobalService globalService;

  LogSection(BuildContext context, {Key? key})
      : globalService = RepositoryProvider.of<GlobalService>(context),
        super(key: key);

  @override
  State<LogSection> createState() => _LogSectionState();
}

class _LogSectionState extends State<LogSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.logService.logHook.subscribe((value, _) {
        double bottomPosition = scrollController.position.maxScrollExtent;
        double currentPosition = scrollController.position.pixels;
        final duration = bottomPosition - currentPosition;
        if (duration < 100 && duration > 0) {
          toBottom();
          currentPosition = bottomPosition;
        }
        setState(() {});
      }),
      widget.globalService.logService.currentPositionHook.subscribe((value, _) {
        switch (value) {
          case CurrentPosition.top:
            toTop();
            break;
          case CurrentPosition.bottom:
            toBottom();
            break;
          case CurrentPosition.unknown:
            break;
        }
      }),
    ]);
    super.initState();
  }

  toBottom() {
    double bottomPosition = scrollController.position.maxScrollExtent;
    double currentPosition = scrollController.position.pixels;
    final duration = bottomPosition - currentPosition;
    scrollController.animateTo(
      bottomPosition,
      duration: Duration(milliseconds: duration ~/ 20),
      curve: Curves.linear,
    );
  }

  toTop() {
    double currentPosition = scrollController.position.pixels;
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: currentPosition ~/ 20),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = widget.globalService.logService.logHook.value;
    final item = Container(
      padding: const EdgeInsets.all(10),
      height: double.infinity,
      width: widget.globalService.logService.maxLogLength.toDouble() * 10,
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
