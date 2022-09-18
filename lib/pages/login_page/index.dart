import 'package:flutter/material.dart';
import 'package:revelation/pages/login_page/devices/lg1024/index.dart';
import 'package:revelation/pages/login_page/devices/phone/index.dart';
import 'package:revelation/service/device_service/index.dart';

class LoginPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        switch (DeviceService.deviceHook.value) {
          case DeviceType.phone:
            return const PhoneLoginPage();
          case DeviceType.windows:
            return const Lg1024LoginPage();
        }
      },
    );
  }
}
