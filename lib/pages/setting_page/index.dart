import 'package:flutter/material.dart';
import 'package:snotes/pages/setting_page/devices/lg1024/index.dart';

class SettingPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => const LG1024SettingPage(),
    );
  }
}
