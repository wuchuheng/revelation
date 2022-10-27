import 'package:flutter/material.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/about_section/about_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/general_section/general_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/log_section/log_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/tab_section/header_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/user_section/user_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class SettingService {
  final GlobalService _globalService;

  SettingService({required GlobalService globalService}) : _globalService = globalService;

  List<TabItemFunc> tabs = [
    (context) => TabItem(
        icon: Icons.settings,
        text: 'General',
        body: GeneralSection(
          context: context,
        )),
    (context) => TabItem(icon: Icons.people, text: 'User', body: UserSection(context)),
    (context) => TabItem(icon: Icons.notes, text: 'Logs', body: LogSection(context)),
    (context) => TabItem(icon: Icons.info_outline, text: 'About', body: const AboutSection()),
  ];

  Hook<int> activeIndexHook = Hook(0);

  void setActiveIndex(int index) => activeIndexHook.set(index);
}
