import 'package:flutter/material.dart';

import '../../service/device_service/index.dart';
import 'devices/lg1024/index.dart';
import 'devices/phone_setting_page/index.dart';

class SettingPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        switch (DeviceService.deviceHook.value) {
          case DeviceType.phone:
            return const PhoneSettingPage();
          case DeviceType.windows:
            return const LG1024SettingPage();
        }
      },
    );
  }
}
