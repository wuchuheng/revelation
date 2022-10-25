import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../routes/route_path.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build Widget App', symbol: 'build');
    return route.build(
      debugShowCheckedModeBanner: false,
      context,
      title: 'Revelation',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF151026),
        ),
        primaryColor: HexColor('#4F23DA'),
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
