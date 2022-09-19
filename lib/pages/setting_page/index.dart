import 'package:flutter/material.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/index.dart';
import 'package:revelation/pages/setting_page/devices/phone_setting_page/index.dart';
import 'package:revelation/service/device_service/index.dart';

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
