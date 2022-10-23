import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../service/device_service/index.dart';
import 'devices/lg1024/index.dart';
import 'devices/phone_home_page/index_page.dart';

class HomePage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        Logger.info('Build widget HomePage', symbol: 'build');

        switch (DeviceService.deviceHook.value) {
          case DeviceType.phone:
            return const PhoneHomePage();
          case DeviceType.windows:
            return const LG1024HomePage();
        }
      },
    );
  }
}
