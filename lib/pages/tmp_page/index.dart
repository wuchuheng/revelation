import 'package:flutter/material.dart' hide MenuItem;
import 'package:intl/intl.dart';
import 'package:snotes/utils/logger.dart';

class TmpPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const Tmp();
      },
    );
  }
}

class Tmp extends StatefulWidget {
  const Tmp({Key? key}) : super(key: key);

  @override
  State<Tmp> createState() => _TmpState();
}

class _TmpState extends State<Tmp> {
  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget  _TmpState.', symbol: 'build');

    final onlineTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse('2022-08-18 11:55:28', true).millisecondsSinceEpoch;
    final localTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse('2022-08-18 12:54:05', true).millisecondsSinceEpoch;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('1660794928000 2022-08-18 11:55:28.264610 $onlineTime'),
            //    1660794928264
            Text('1660755245000 2022-08-18 12:54:05.454666 $localTime'),
            //    1660798445454
          ],
        ),
      ),
    );
  }
}
