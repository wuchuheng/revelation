import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/service/global_service.dart';

import '../../service/device_service/device_service.dart';
import 'devices/lg1024/lg1024.dart';
import 'devices/phone_setting_page/phone_setting_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const SettingPage());

  @override
  Widget build(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);

    switch (DeviceService.deviceHook.value) {
      case DeviceType.phone:
        return PhoneSettingPage(globalService: globalService);
      case DeviceType.windows:
        return LG1024SettingPage(globalService: globalService);
    }
  }
}
