import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/device_service/index.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(Config.windowSize);
    DeviceService.setDevice(DeviceType.windows);
  } else if (Platform.isAndroid || Platform.isIOS) {
    DeviceService.setDevice(DeviceType.phone);
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build Widget App', symbol: 'build');
    return route.build(
      debugShowCheckedModeBanner: false,
      context,
      // Todo:  Change title
      title: 'snotes',
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
