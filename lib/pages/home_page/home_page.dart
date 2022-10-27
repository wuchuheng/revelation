import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../service/device_service/device_service.dart';
import 'devices/lg1024/lg1024.dart';
import 'devices/phone_home_page/phone_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const HomePage());

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
