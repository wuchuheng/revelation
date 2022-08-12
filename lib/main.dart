import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:snotes/routes/route_path.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoutePath.getAppPathInstance().build(
      context,
      title: 'snote',
      theme: ThemeData(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
