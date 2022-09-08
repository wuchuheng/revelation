import 'package:flutter/material.dart';
import 'package:snotes/service/log_service/index.dart';
import 'package:snotes/utils/date_time_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

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
          if (duration < 100) {
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
    return Container(
      padding: const EdgeInsets.all(10),
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
        controller: scrollController,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          final dateTime = log.dateTime;
          Color typeColor = Colors.black;
          switch (log.type) {
            case LoggerType.info:
              typeColor = Colors.green;
              break;
            case LoggerType.error:
              typeColor = Colors.red;
              break;
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 65,
                  child: Text(
                    '${DateTimeUtil.formatHour(dateTime)}:${DateTimeUtil.formatMinute(dateTime)}:${DateTimeUtil.formatSecond(dateTime)}  ',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                Container(
                  color: typeColor,
                  padding: const EdgeInsets.all(1),
                  child: Text(
                    '${log.type.name} ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(' ${log.message}  '),
                Text(log.file, style: const TextStyle(color: Colors.blueAccent)),
              ],
            ),
          );
        },
      ),
    );
  }
}
