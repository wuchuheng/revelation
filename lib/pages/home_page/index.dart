import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../service/device_service/index.dart';
import 'devices/lg1024/index.dart';
import 'devices/phone_home_page/index_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => HomePage());

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget HomePage', symbol: 'build');

    switch (DeviceService.deviceHook.value) {
      case DeviceType.phone:
        return const PhoneHomePage();
      case DeviceType.windows:
        return const LG1024HomePage();
    }
  }
}
