import 'package:flutter/material.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/about_section/about_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/general_section/general_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/log_section/log_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/tab_section/header_section.dart';
import 'package:revelation/pages/setting_page/devices/lg1024/user_section/user_section.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class SettingService {
  static List<TabItem> tabs = [
    TabItem(icon: Icons.settings, text: 'General', body: const GeneralSection()),
    TabItem(icon: Icons.people, text: 'User', body: const UserSection()),
    TabItem(icon: Icons.notes, text: 'Logs', body: const LogSection()),
    TabItem(icon: Icons.info_outline, text: 'About', body: const AboutSection()),
  ];

  static Hook<int> activeIndexHook = Hook(0);

  static void setActiveIndex(int index) => activeIndexHook.set(index);
}
