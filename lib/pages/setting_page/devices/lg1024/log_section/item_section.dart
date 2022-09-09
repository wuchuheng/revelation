import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../utils/date_time_util.dart';

class ItemSection extends StatelessWidget {
  final LoggerItem log;
  const ItemSection({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
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
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Text(' ${log.message}  '),
          Text(log.file, style: const TextStyle(color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
