import 'package:flutter/material.dart';
import 'package:snotes/pages/home_page/devices/lg1024/index.dart';
import 'package:snotes/utils/logger.dart';

class HomePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const _HomePage();
      },
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget HomePage', symbol: 'build');
    return const LG1024HomePage();
  }
}
