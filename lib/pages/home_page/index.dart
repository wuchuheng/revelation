import 'package:flutter/material.dart';
import 'package:revelation/pages/home_page/devices/lg1024/index.dart';
import 'package:revelation/service/device_service/index.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'devices/phone_home_page/index_page.dart';

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
    Logger.info('Build widget HomePage', symbol: 'build');
    switch (DeviceService.deviceHook.value) {
      case DeviceType.phone:
        return const PhoneHomePage();
        break;
      case DeviceType.windows:
        return const LG1024HomePage();
        break;
    }
  }
}
