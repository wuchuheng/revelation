import 'package:flutter/material.dart';

import '../../service/device_service/device_service.dart';
import 'devices/lg1024/lg1024.dart';
import 'devices/phone_setting_page/phone_setting_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const SettingPage());

  @override
  Widget build(BuildContext context) {
    switch (DeviceService.deviceHook.value) {
      case DeviceType.phone:
        return const PhoneSettingPage();
      case DeviceType.windows:
        return const LG1024SettingPage();
    }
  }
}
